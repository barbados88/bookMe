//
//  BookNew.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class BookNew: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var _collectionView: UICollectionView!

    var books : [Book] = []
    var segueDelegate : SegueDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _collectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count > 4 ? 4 : books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : (UIScreen.main.bounds.size.width - 40) / 2, height : (UIScreen.main.bounds.size.width - 40) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookNewCell
        cell.book = books[indexPath.row]
        cell.favouriteButton.isHidden = segueDelegate is CatalogueViewController
        cell.configureWith(books[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.processVisibleItems()
        segueDelegate?.performSegue(with: "book", sender: books[indexPath.row])
    }
    
}
