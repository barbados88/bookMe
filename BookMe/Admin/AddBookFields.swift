//
//  ViewController.swift
//  BookMe
//
//  Created by mac on 21.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

extension AddBookViewController {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == NSLocalizedString("Штрих-код", comment: "") {
            book.barcode = textField.text
        } else if textField.placeholder == NSLocalizedString("Категория", comment: "") {
            book.categoryName = textField.text
        } else if textField.placeholder == NSLocalizedString("Название", comment: "") {
            book.name = textField.text
        } else if textField.placeholder == NSLocalizedString("Автор", comment: "") {
            book.author = textField.text
        } else if textField.placeholder == NSLocalizedString("Ссылка", comment: "") {
            book.link = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = _tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BookCell
        if textField.placeholder == NSLocalizedString("Штрих-код", comment: "") {
            cell.categoryTextField.becomeFirstResponder()
        } else if textField.placeholder == NSLocalizedString("Категория", comment: "") {
            cell.nameTextField.becomeFirstResponder()
        } else if textField.placeholder == NSLocalizedString("Название", comment: "") {
            cell.authorTextField.becomeFirstResponder()
        } else if textField.placeholder == NSLocalizedString("Автор", comment: "") {
            cell.linkTextField.becomeFirstResponder()
        } else if textField.placeholder == NSLocalizedString("Ссылка", comment: "") {
            self.view.endEditing(true)
        }
        return false
    }
    //TODO: create validator for fields
    var isValidFields : Bool {
        if book.barcode == nil || book.barcode?.count == 0 {
            let cell = _tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextCell
            cell.textField.shake()
            cell.textField.becomeFirstResponder()
            return false
        }
        if book.categoryName == nil || book.categoryName?.count == 0 {
            let cell = _tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! BookCell
            cell.categoryTextField.shake()
            cell.categoryTextField.becomeFirstResponder()
            return false
        }
        if book.name == nil || book.name?.count == 0 {
            let cell = _tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! BookCell
            cell.nameTextField.shake()
            cell.nameTextField.becomeFirstResponder()
            return false
        }
        if book.author == nil || book.author?.count == 0 {
            let cell = _tableView.cellForRow(at: IndexPath(row:2, section: 1)) as! BookCell
            cell.authorTextField.shake()
            cell.authorTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    
}
