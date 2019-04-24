//
//  ViewController.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import RealmSwift
import AMScrollingNavbar

class CatalogueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SegueDelegate, ScrollingNavigationControllerDelegate {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var array : [[Any]] = []
   
    
    var notificationToken: NotificationToken?
    var realm: Realm = try! Realm()
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIBs()
        addObservers()
        fullOnData()
        setupRealm()
    }
    //TODO: update if admin added books
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationSettings()
    }
    
    //MARK - UITableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : array[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return array[section].count == 0 ? 0.1 : 39
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 44 : newBooksCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if array[section].count == 0 {return nil}
        let headerView = HeaderView.configure(with: 39)
        headerView.headerLabel.text = array[section].first is Book ? NSLocalizedString("НОВИНКИ", comment: "") : NSLocalizedString("КАТЕГОРИИ КНИГ", comment: "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if array[indexPath.section][indexPath.row] is Book {
            return bookCell(at: indexPath)
        }
        if array[indexPath.section][indexPath.row] is Category {
            return categoryCell(at: indexPath)
        }
        return noCell
    }
    
    func bookCell(at indexPath: IndexPath) -> BookNew {
        let cell = _tableView.dequeueReusableCell(withIdentifier: "BookNew") as! BookNew
        cell.books = array[indexPath.section] as! [Book]
        cell._collectionView.reloadData()
        cell.segueDelegate = self
        return cell
    }
    
    func categoryCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        let category = array[indexPath.section][indexPath.row] as! Category
        cell.textLabel?.text = category.name
        return cell
    }
    
    var noCell : UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            performSegue(withIdentifier: "category", sender: array[indexPath.section][indexPath.row] as! Category)
        }
    }
    
    //MARK - Helper methods
    
    private func registerNIBs() {
        _tableView.register(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "BookNew")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCards), name: .firstTab, object: nil)
    }
    
    private func fullOnData() {
        addActivity()
        Communicator.getCategories(completion: { [weak self] success in
            guard let wself = self else {return}
            wself.removeActivity(animated: true)
            if success == false {return}
            wself.addDataFromRealm()
            wself.manageEmptyView()
        })
    }
    
    private func addDataFromRealm() {
        array.removeAll()
        let categories = realm.objects(Category.self).sorted(byKeyPath: "priority", ascending: true).value(forKey: "self") as! [Category]
        let books = realm.objects(Book.self).value(forKey: "self") as! [Book]
        if categories.count > 0 {
            array.append(categories)
        }
        if books.count > 0 {
            array.append(books)
        }
        _tableView.reloadData()
    }
    
    private func manageEmptyView() {
        emptyView.isHidden = array.first?.count ?? 0 > 0 || array.last?.count ?? 0 > 0
        emptyLabel.text = Session.admin == true ? NSLocalizedString("В данный момент каталог пуст, на правах администратора вы можете добалять книги и категории в каталог", comment: "") :  NSLocalizedString("В данный момент каталог пуст, чтобы здесь появились книги обратитесь к администартору", comment:"")
    }
    
    private var newBooksCellHeight: CGFloat {
        return array.first?.count ?? 0 > 2 ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.width / 2
    }
    
    @objc private func updateCards() {
        
    }
    
    internal func performSegue(with identifier: String, sender: Any?) {
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    private func navigationSettings() {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(_tableView, delay: 50.0)
        }
    }
    
    func setupRealm() {
        let username = "test"
        let password = "woxapp12345"
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: Constants.syncAuthURL) { user, error in
            guard let user = user else {
                print("Error syncing data: \(error?.localizedDescription ?? "Error")")
                DispatchQueue.main.async {
                    self.addDataFromRealm()
                }
                return
            }
            DispatchQueue.main.async {
                let types = [Book.self, Category.self, Reader.self, History.self, Company.self]
                Realm.Configuration.defaultConfiguration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: Constants.syncServerURL!),
                    objectTypes: types
                )
                let realm = try! Realm()
                try! realm.write {
                    realm.add(Book(), update: true)
                    realm.add(Category(), update: true)
                    realm.add(Reader(), update: true)
                    realm.add(History(), update: true)
                    realm.add(Company(), update: true)
                }
                self.addDataFromRealm()
                self.notificationToken = self.realm.observe { _, realm in
                    self.addDataFromRealm()
                }
            }
        }
    }
    
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "book" {
            let vc = segue.destination as? BookViewController
            vc?.book = sender as! Book
        } else if segue.identifier == "category" {
            let vc = segue.destination as? CategoryViewController
            vc?.category = sender as! Category
        } else if segue.identifier == "fastRead" {
            let nvc = segue.destination as? UINavigationController
            let vc = nvc?.viewControllers.first as? ScanViewController
            vc?.fastRead = true
        }
    }
    
    
    @IBAction func unwindCatalogue(_ segue: UIStoryboardSegue) { }

}

