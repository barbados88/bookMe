//
//  History.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

extension CategoryViewController {

    func checkHistory() {
        let history = TabBarController.shared.index == 3
        if history == true {
            let realm = try! Realm()
            books = realm.objects(History.self).first?.books.value(forKey: "self") as! [Book]
            emptyHistory()
        }
    }
    
    //MARK - Actions
    
    @IBAction func clearHistory(_ sender: UIBarButtonItem) {
        History.clearHistory()
        emptyHistory()
    }
    
    //MARK - Helper methods
    
    func emptyHistory() {
        let hView = Bridge(emptyView: EmptyHistory())
        emptyView.isHidden = hView.shouldHide(books.count)
        fishView.fillInfo(emptyView: hView.emptyView)
        deleteButton.image = books.count > 0 ? UIImage(named: "basket") : nil
        deleteButton.isEnabled = books.count > 0
        self.navigationItem.leftBarButtonItem?.image = nil
        self.navigationItem.title = hView.screenTitle
    }
    
}
