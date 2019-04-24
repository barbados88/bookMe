//
//  CommentEx.swift
//  tamak
//
//  Created by mac on 21.06.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class CommentEx: ImagePickerManager, UITextViewDelegate {

    var tableView : UITableView = UITableView()
    var counterLabel : UILabel? = nil
    var comment : String? = nil
    var padding : CGFloat = 100.0
    var indexPath : IndexPath? = nil
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    internal func enableButton(){}
    
    internal func addObservers() {
        removeObservers()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHidden(notification:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    internal func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
}

extension CommentEx {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        enableButton()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        comment = textView.text
        let counter = textView.text.count
        currentCell.placeholderLabel.isHidden = counter > 0
        counterLabel?.text = "\(counter) / 255"
        counterLabel?.textColor = counter > 255 ? UIColor.red : UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.38)
        tableUpdates()
    }
    
    internal func keyboardShown(notification : Notification) {
        if let info = (notification as NSNotification).userInfo {
            if let keyboard = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                insetWithBottom(bottom: keyboard.height - padding)
                tableUpdates()
            }
        }
    }
    
    internal func keyboardHidden(notification : Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.insetWithBottom(bottom: 0.0)
        })
    }
    
    private func insetWithBottom(bottom : CGFloat) {
        let inset = UIEdgeInsetsMake(tableView.contentInset.top, 0.0, bottom, 0.0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
    }
    
    private func tableUpdates() {
        if currentCell.textView == nil {return}
        currentCell.textView.delegate = self
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        currentCell.textView.scrollRangeToVisible(NSMakeRange(currentCell.textView.text.count - 1, 0))
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        if currentCell.textView.isFirstResponder == true {
            tableView.scrollToRow(at: lastPath, at: .bottom, animated: false)
        }
    }
    
    internal var currentCell : CommentCell {
        return tableView.cellForRow(at: lastPath) as? CommentCell ?? CommentCell()
    }

    private var lastPath : IndexPath {
        return indexPath ?? IndexPath(row: tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1, section: tableView.numberOfSections - 1)
    }
    
}
