//
//  FastViewController.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

extension ScanViewController {
    
    func takeBook() {
        let realm = try! Realm()
        if let book = realm.objects(Book.self).filter("barcode = %@", code ?? "").first {
            book.readBook()
            ServerError.stringError(code: 780)
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            ServerError.stringError(code: 779)
        }
    }


}
