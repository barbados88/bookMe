//
//  Favourites.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

extension CategoryViewController {
    
    //MARK - Helper methods
    
    func checkFavourites() {
        let favourite = TabBarController.shared.index == 1
        if favourite == true {
            let realm = try! Realm()
            books = realm.objects(Book.self).value(forKey: "self") as! [Book]
            books = books.filter({ return $0.isFavourite == true })
            let fView = Bridge(emptyView: EmptyFavourites())
            emptyView.isHidden = fView.shouldHide(books.count)
            fishView.fillInfo(emptyView: fView.emptyView)
            self.navigationItem.leftBarButtonItem?.image = nil
            self.navigationItem.title = fView.screenTitle
        }
    }
    
}
