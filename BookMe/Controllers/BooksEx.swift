//
//  Books.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift

extension CategoryViewController {

    //MARK - Actions
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        filterBooks()
    }
    
    //MARK - Helper methods
    
    func checkLists() {
        let list = TabBarController.shared.index == 2
        if list == true {
            topSpace.constant = 0
            self.view.layoutIfNeeded()
            filterBooks()
            let bView = Bridge(emptyView: EmptyBooks())
            emptyView.isHidden = bView.shouldHide(books.count)
            fishView.fillInfo(emptyView: bView.emptyView)
            self.navigationItem.leftBarButtonItem?.image = nil
            self.navigationItem.title = bView.screenTitle
        }
    }
    
    func filterBooks() {
        let realm = try! Realm()
        books = realm.objects(Book.self).value(forKey: "self") as! [Book]
        books = _segmentedControl.selectedSegmentIndex == 0 ? books.filter({ return $0.isRead == true }) : books.filter({ return $0.isReserved == true })
        _collectionView.reloadData()
    }
    
}
