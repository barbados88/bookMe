//
//  Communicator.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class Communicator: NSObject {
    
    static let shared = Communicator()
    var sessionManager = Alamofire.SessionManager()
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    private static var manager : Alamofire.SessionManager {
        return Communicator.shared.sessionManager
    }
    
    private static var API_KEY : String {
        return "AIzaSyBJQ6HQFlaKsT6Wzc1TJp3Q9j_Yj4bp-5M"
    }
    
    private static var API_PREFIX : String {
        return "http://45.76.138.82/"
    }
    
    static var isConnected: Bool {
        if Reachability.isConnectedToNetwork() == true {
            return true
        } else {
            let _ = gotError(dictionary: ["status_id" : 777])
            return false
        }
    }
    
    private static var headers : [String : String] {
        var headers : [String : String] = [:]
        headers["user_id"] = "\(Session.userID)"
        headers["token"] = Session.accessToken
        return headers
    }
    
    private static func sendRequest(request : String, method: Alamofire.HTTPMethod, parameters: [String : Any]?, useHeaders : Bool, completion : @escaping(_ response : [String : AnyObject]) -> Void) {
        if isConnected == false {return}
        let encoding : ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        manager.request(request, method: method, parameters: parameters, encoding: encoding, headers: useHeaders == true ? headers : nil).responseJSON(completionHandler: { response in
            checkResponse(response: response, completion: { response in
                completion(response)
            })
        })
    }
    
    static func checkResponse(response : DataResponse<Any>, completion: @escaping (_ response : [String : AnyObject]) -> Void) {
        guard let dictionary = response.result.value as? [String : AnyObject]
            else {
                manageTimeout(response: response)
                completion([:])
                return
        }
        if gotError(dictionary: dictionary) == false {
            completion(dictionary)
        }
    }
    
    static func gotError(dictionary : [String : Any]) -> Bool {
        if let status = dictionary["code"] as? Int {
            if status != 1 {
                ServerError.stringError(code: status)
                return true
            }
        }
        return false
    }
    
    static func manageTimeout(response : DataResponse<Any>) {
        if let error = response.result.error {
            if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCannotFindHost {
                ServerError.stringError(code: 777)
            } else {
                if error._code != -999 || error._code != -1005 {
                    ServerError.show(alert: error.localizedDescription, nil, nil)
                }
            }
        }
    }
    
    static func authInApp(completion : @escaping(_ success : Bool) -> Void) {
        let request = "\(API_PREFIX)auth"
        var parameters : [String : String] = [:]
        parameters["key"] = API_KEY
        parameters["password"] = Session.password
        parameters["email"] = Session.mail
        sendRequest(request: request, method: .post, parameters: parameters, useHeaders: false, completion: { response in
            if let token = response["token"] as? String {
                Session.accessToken = token
                Session.companyID = response["company_id"] as? Int ?? -1
                Session.userID = response["user_id"] as? Int ?? -1
                Session.name = response["user_name"] as? String
                Session.surname = response["user_last_name"] as? String
                Session.admin = response["user_type"] as? Int == 2
                Session.userLoggedIn = true
                completion(true)
                return
            }
            completion(false)
        })
    }
    
    static func recoverPassword(completion : @escaping(_ success : Bool) -> Void) {
        let request = "\(API_PREFIX)"
        var parameters : [String : String] = [:]
        parameters[""] = API_KEY
        parameters[""] = Session.mail
        sendRequest(request: request, method: .put, parameters: parameters, useHeaders: true, completion: { response in
            
        })
    }
    
    static func getCategories(completion : @escaping(_ success : Bool) -> Void) {
        let request = "\(API_PREFIX)categories"
        var parameters : [String : Any] = [:]
        parameters["company_id"] = Session.companyID
        sendRequest(request: request, method: .get, parameters: parameters, useHeaders: true, completion: { response in
            if let categories = response["categories"] as? [[String : AnyObject]] {
                Utils.realm({ realm in
                    for category in categories {
                        realm.add(Category.initWith(dictionary: category), update: true)
                    }
                })
            }
            if let books = response["new_books"] as? [[String : AnyObject]] {
                Utils.realm({ realm in
                    for book in books {
                        realm.add(Book.initWith(dictionary: book), update: true)
                    }
                })
            }
            completion(true)
        })
    }
    
    static func getCategory(category : Category, completion : @escaping(_ success : Bool) -> Void) {
        let request = "\(API_PREFIX)categories/\(category.categoryID)"
        sendRequest(request: request, method: .get, parameters: nil, useHeaders: true, completion: { response in
            if let books = response["books"] as? [[String : AnyObject]] {
                category.addBooks(array : books)
            }
            completion(true)
        })
    }
    
    static func getBook(book : Book, completion : @escaping(_ success : Bool) -> Void) {
        let request = "\(API_PREFIX)books/\(book.bookBarcode)"
        sendRequest(request: request, method: .get, parameters: nil, useHeaders: true, completion: { response in
            Utils.realm({ realm in
                realm.add(Book.initWith(dictionary: response), update: true)
            })
            completion(true)
        })
    }
    
    static func readBook(id: String) {
        let request = "\(API_PREFIX)books/\(id)/take"
        sendRequest(request: request, method: .put, parameters: nil, useHeaders: true, completion: { response in
            print("\(response)")
        })
    }
    
    static func reserveBook(id: String) {
        let request = "\(API_PREFIX)books\(id)/reserve"
        sendRequest(request: request, method: .post, parameters: nil, useHeaders: true, completion: { response in
            print("\(response)")
        })
    }
    
    static func returnBook(id: String) {
        let request = "\(API_PREFIX)books\(id)/return"
        sendRequest(request: request, method: .put, parameters: nil, useHeaders: true, completion: { response in
            print("\(response)")
        })
    }
    
    static func addBook(book : Book) {
        let request = "\(API_PREFIX)books"
        var parameters : [String : Any] = [:]
        parameters["book_name"] = book.bookName
        parameters["book_description"] = book.bookDescription
        parameters["barcode"] = book.bookBarcode
        parameters["author"] = book.bookAuthor
        parameters["link_book_online"] = book.bookLink
        parameters["category_name"] = book.bookCategory
        parameters["image"] = ""
        parameters["company_id"] = Session.companyID
        sendRequest(request: request, method: .post, parameters: parameters, useHeaders: true, completion: { response in
            print(response)
        })
    }
    
    static func logout() {
        let request = "\(API_PREFIX)logout"
        sendRequest(request: request, method: .get, parameters: nil, useHeaders: true, completion: {_ in})
    }
    
}
