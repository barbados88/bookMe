//
//  AddBookToCategory.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

extension AddBookViewController {

    func addBookToCategory() {
        Utils.realm { realm in
            if let _ = realm.objects(Book.self).filter("barcode = %@", book.bookBarcode).first {
                ServerError.stringError(code: 778)
                return
            } else {
                realm.add(book, update: true)
            }
        }
        Communicator.addBook(book: book)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
