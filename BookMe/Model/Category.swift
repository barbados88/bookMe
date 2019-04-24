//
//  Category.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {
    
    dynamic var id : Int = 0
    dynamic var categoryName : String? = nil
    dynamic var priority : Int = 0
    var books = List<Book>()
    
    override static func primaryKey() -> String {
        return "categoryName"
    }
    
    static func initWith(dictionary : [String : AnyObject]) -> Category {
        let category = Category()
        category.id = dictionary["category_id"] as? Int ?? 0
        category.categoryName = dictionary["category_name"] as? String
        category.priority = dictionary["sort"] as? Int ?? 0
        return category
    }
    
    func addBooks(array : [[String : AnyObject]]) {
        Utils.realm({ realm in
            self.books.removeAll()
            for book in array {
                self.addBook(book: book)
            }
        })
    }
    
    func addBook(book : [String : AnyObject]) {
        let book = Book.initWith(dictionary: book)
        realm?.add(book, update: true)
        books.append(book)
    }
    
    var name: String {
        return categoryName ?? "Название категории"
    }
    
    var categoryID: Int {
        return id
    }
    
}
