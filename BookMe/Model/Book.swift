//
//  Book.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

class Book: Object {

    dynamic var categoryName : String? = nil
    dynamic var author : String? = nil
    dynamic var name : String? = nil
    dynamic var link : String? = nil
    dynamic var bDescription : String? = nil
    dynamic var barcode : String? = nil
    dynamic var imageURL : String? = nil
    dynamic var imageData : Data? = nil
    dynamic var isFavourite : Bool = false
    dynamic var isRead : Bool = false
    dynamic var isReserved : Bool = false
    dynamic var tookTime : Date? = nil
    dynamic var backTime : Date? = nil
    dynamic var user : Reader? = nil
    
    override static func primaryKey() -> String {
        return "barcode"
    }
    
    static func initWith(dictionary : [String : AnyObject]) -> Book {
        let book = Book()
        book.barcode = dictionary["barcode"] as? String
        book.name = dictionary["book_name"] as? String
        book.bDescription = dictionary["book_description"] as? String
        book.author = dictionary["book_author"] as? String
        book.imageURL = dictionary["image"] as? String
        book.link = dictionary["link_book_online"] as? String
        book.isRead = dictionary["book_status"] as? Int == 1
        book.user = Reader.initWith(dictionary: dictionary)
        return book
    }
    
    var bookName: String {
        return name ?? NSLocalizedString("Название книги", comment: "")
    }
    
    var bookAuthor: String {
        return author ?? NSLocalizedString("Автор неизвестен", comment: "")
    }
    
    var bookDescription: String {
        return bDescription ?? NSLocalizedString("Нет описания", comment: "")
    }
    
    var bookLink: String {
        return link ?? ""
    }
    
    var bookBarcode: String {
        return barcode ?? ""
    }
    
    var bookCategory: String {
        return categoryName ?? ""
    }
    
    var image: UIImage? {
        if imageData != nil {
            return UIImage(data: imageData!)
        }
        return nil
    }
    
    var icon: UIImage {
        if imageData != nil {
            return UIImage(data: imageData!) ?? UIImage(named: "book") ?? UIImage()
        }
        return UIImage(named: "book") ?? UIImage()
    }
    
    var readTime: String {
        if tookTime == nil {
            return ""
        }
        if backTime == nil {
            return String(format : "%@ %@",NSLocalizedString("Читаю уже", comment: ""), tookTime!.period(to : backTime ?? Date()))
        }
        return String(format : "%@ %@",NSLocalizedString("Вернул через", comment: ""), tookTime!.period(to : backTime ?? Date()))
    }
    
    func addToFavourite() {
        let realm = try! Realm()
        try! realm.write() {
            isFavourite = !isFavourite
        }
    }
    
    func readBook() {
        Utils.realm { _ in
            isRead = !isRead
            if isRead == true {
                History.took(book: self)
                Communicator.readBook(id: bookBarcode)
            } else {
                History.back(book: self)
                Communicator.returnBook(id: bookBarcode)
            }
        }
    }
    
    func reserveBook() {
        Utils.realm { _ in
            isReserved = !isReserved
            Communicator.reserveBook(id: bookBarcode)
        }
    }
    
}
