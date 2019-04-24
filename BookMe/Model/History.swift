//
//  History.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

class History: Object {

    var books = List<Book>()
    dynamic var id : Int = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func took(book : Book) {
        let realm = try! Realm()
        let history = realm.objects(History.self).first
        book.tookTime = Date()
        history?.books.append(book)
    }
    
    static func back(book : Book) {
        let realm = try! Realm()
        let history = realm.objects(History.self).first
        if let b = history?.books.filter("barcode = %@", book.barcode ?? "").first {
            b.backTime = Date()
        }
    }
    
    static func clearHistory() {
        Utils.realm({ realm in
            realm.delete(realm.objects(History.self))
        })
    }
    
}
