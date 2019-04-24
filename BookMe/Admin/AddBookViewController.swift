//
//  AddBookViewController.swift
//  BookMe
//
//  Created by mac on 21.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class AddBookViewController: CommentEx, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, WXImagePickerDelegate {

    var book : Book = Book()
    var array : [String] = []
    
    @IBOutlet weak var _tableView: UITableView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initArray()
        registerNIBs()
        wxDelegate = self
        self.tableView = _tableView
        self.padding = 0
    }
    
    //MARK - UITableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {return UITableViewAutomaticDimension}
        return indexPath.section == 1 ? 200 : 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 39
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView.configure(with: 39)
        headerView.headerLabel.text = array[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextCell
            cell.textField.text = book.bookBarcode
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! BookCell
            cell.configure(with: book)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell") as! CommentCell
        cell.textView.text = comment
        cell.textView.delegate = self
        return cell
    }
    
    //MARK - Actions
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: "BookME", message: NSLocalizedString("Добавьте фото к книге", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Сделать фото", comment: ""), style: .default, handler: { _ in
            self.takeFoto()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Выбрать из галереи", comment: ""), style: .default, handler: { _ in
            self.selectFoto()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        if isValidFields == false {return}
        addBookToCategory()
    }
    
    func didFinishPicking(image : UIImage?, info : [String : Any]) {
        if image == nil {return}
        book.imageData = UIImageJPEGRepresentation(image!, 1.0)
        _tableView.reloadSections([1], with: .automatic)
    }
    
    //MARK - Helper methods
    
    private func registerNIBs() {
        _tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "textCell")
    }
    
    private func initArray() {
        array.append(NSLocalizedString("БАРКОД", comment: ""))
        array.append(NSLocalizedString("ИНФОРМАЦИЯ О КНИГЕ", comment: ""))
        array.append(NSLocalizedString("ОПИСАНИЕ", comment: ""))
    }
    
    //MARK - Delegate methods
    
    func textViewDidEndEditing(_ textView: UITextView) {
        book.bDescription = textView.text
    }
    
    
}
