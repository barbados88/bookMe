//
//  CategoryViewController.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import CSStickyHeaderFlowLayout

enum ViewType : Int {
    case list
    case grid
}

class CategoryViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IndexScrollDelegate {

    var category : Category = Category()
    var viewType : ViewType = .list
    var books : [Book] = []
    var headers : [String] = []
    var fishView : FishView = FishView()
    
    @IBOutlet weak var _segmentedControl: UISegmentedControl!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var listButton: UIBarButtonItem!
    @IBOutlet weak var _searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSettings()
        registerNIBs()
        addObservers()
    }
    //TODO: scroll to index should be done
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fullOnArray()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fishView.fixFrame()
    }
    
    //MARK - UICollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewType == .list ? CGSize(width : collectionView.frame.size.width, height : 90) : CGSize(width: (UIScreen.main.bounds.size.width - 40) / 2, height : (UIScreen.main.bounds.size.width - 40) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewType == .list ? UIEdgeInsets.zero : UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader && viewType == .list {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            cell.headerLabel.text = "A"
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = _collectionView.dequeueReusableCell(withReuseIdentifier: viewType == .list ? "PlainBookCell" : "BookCell", for: indexPath) as! BookNewCell
        cell.book = books[indexPath.row]
        cell.history = TabBarController.shared.index == 3
        cell.configureWith(books[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.processVisibleItems()
        performSegue(withIdentifier: "book", sender: books[indexPath.row])
    }
    
    //MARK - Actions
    
    @IBAction func reorderView(_ sender: Any) {
        viewType = viewType == .list ? .grid : .list
        listButton.image = viewType == .list ? #imageLiteral(resourceName: "list") : #imageLiteral(resourceName: "grid")
        _collectionView.reloadSections(IndexSet(integer: 0))
        (_collectionView.collectionViewLayout as? CSStickyHeaderFlowLayout)?.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: viewType == .list ? 20.0 : 0.0)
    }
    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sort(_ sender: Any) {
        askSort()
    }
    
    //MARK - Helper methods
    
    private func startSettings() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = category.name
        fishView = FishView.configure(inView: emptyView)
        (_collectionView.collectionViewLayout as? CSStickyHeaderFlowLayout)?.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 20)
    }
    
    private func addObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.second), name: .secondTab, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.third), name: .thirdTab, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.fourth), name: .fourthTab, object: nil)
    }

    private func registerNIBs() {
        _collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
        _collectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        _collectionView.register(UINib(nibName: "PlainBookCell", bundle: nil), forCellWithReuseIdentifier: "PlainBookCell")
    }
    
    private func fullOnArray() {
        skipToStartSettings()
        checkCategory()
        checkFavourites()
        checkLists()
        checkHistory()
        manageSortButton()
        _collectionView.reloadData()
    }
    
    private func skipToStartSettings() {
        topSpace.constant = -44
        self.view.layoutIfNeeded()
        deleteButton.image = nil
        deleteButton.isEnabled = false
    }
    
    private func checkCategory() {
        let categoryIn = TabBarController.shared.index == 0
        if categoryIn == true {
            books = category.books.array as! [Book]
            if books.count == 0 {self.addActivity()}
            Communicator.getCategory(category: category, completion: { [weak self] success in
                guard let wself = self else {return}
                wself.books = wself.category.books.array as! [Book]
                wself.removeActivity(animated: true)
                wself._collectionView.reloadData()
            })
        }
    }
    
    private func askSort() {
        let alert = UIAlertController(title: "BookME", message: NSLocalizedString("Выберите метод сортировки", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Сортировать по заголовкам", comment: ""), style: .default, handler: {_ in}))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Сортировать по авторам", comment: ""), style: .default, handler: {_ in}))
        present(alert, animated: true, completion: nil)
    }
    
    private func manageSortButton() {
        sortButton.isEnabled = books.count != 0
        sortButton.image = books.count != 0 ? #imageLiteral(resourceName: "icon_sort") : nil
        listButton.isEnabled = books.count != 0
        listButton.image = books.count != 0 ? viewType == .list ? #imageLiteral(resourceName: "list") : #imageLiteral(resourceName: "grid") : nil
    }
    
    private func fillInHeaders() {
        
    }
    
    internal func scrollTo(section: Int) {
        _collectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .top, animated: true)
    }
    
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "book" {
            let vc = segue.destination as? BookViewController
            vc?.book = sender as! Book
        }
    }

}
