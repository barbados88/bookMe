//
//  BookViewController.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var book : Book = Book()

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var reserverButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var verticalSpace: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationItem.title = book.name
        getBook()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        countTableHeight()
    }
    
    //MARK - UITableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35))
        headerView.backgroundColor = .clear
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 16, width: tableView.frame.size.width, height: 15))
        headerLabel.font = UIFont(name:"SFUIText-Regular", size: 13.0)
        headerLabel.textColor = UIColor(red: 109 / 255.0, green: 109 / 255.0, blue: 114 / 255.0, alpha: 1.0)
        headerView.addSubview(headerLabel)
        headerLabel.text = NSLocalizedString("СТАТИСТИКА", comment: "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Статистика от сервера"
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK - Actions
    @IBAction func reserveBook(_ sender: UIButton) {
        book.reserveBook()
        sender.isSelected = !sender.isSelected
        reserveTitle(sender)
    }
    
    @IBAction func readBook(_ sender: UIButton) {
        book.readBook()
        sender.isSelected = !sender.isSelected
        readTitle(sender)
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        book.addToFavourite()
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openInSafari(_ sender: Any) {
        if let url = URL(string: book.bookLink) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                ServerError.stringError(code: 781)
            }
        } else {
            ServerError.stringError(code: 781)
        }
    }
    
    //MARK - Helper methods

    func getBook() {
        addActivity()
        bookInfo()
        Communicator.getBook(book: book, completion: { [weak self] success in
            guard let wself = self else {return}
            wself.readOnlineButton()
            wself.bookInfo()
            wself.removeActivity(animated: true)
        })
    }
    
    func bookInfo() {
        bookImageView.image = book.icon
        nameLabel.text = book.bookName
        authorLabel.text = book.bookAuthor
        descriptionLabel.text = book.bookDescription
        reserverButton.isSelected = book.isReserved
        favouriteButton.isSelected = book.isFavourite
        readButton.isSelected = book.isRead
        reserveTitle(reserverButton)
        readTitle(readButton)
    }
    
    func reserveTitle(_ sender : UIButton) {
        sender.setTitle(sender.isSelected ? NSLocalizedString("В резерве", comment: "") : NSLocalizedString("Резерв", comment: ""), for: .normal)
        readButton.isEnabled = !sender.isSelected
        readButton.alpha = readButton.isEnabled == true ? 1.0 : 0.5
    }
    
    func readTitle(_ sender : UIButton) {
        sender.setTitle(sender.isSelected ? NSLocalizedString("Вернуть", comment: "") : NSLocalizedString("Читать", comment: ""), for: .normal)
        reserverButton.isEnabled = !sender.isSelected
        reserverButton.alpha = reserverButton.isEnabled == true ? 1.0 : 0.5
    }
    
    func countTableHeight() {
        tableHeight.constant = CGFloat(5 * 44.0 + 30.0 + 36)
    }
    
    func readOnlineButton() {
        verticalSpace.constant = book.link == nil ? -45 : 10
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}
