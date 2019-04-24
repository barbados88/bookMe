//
//  BookCell.swift
//  BookMe
//
//  Created by mac on 21.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    func configure(with book: Book) {
        bookImageView.image = book.image
        categoryTextField.text = book.categoryName
        nameTextField.text = book.name
        authorTextField.text = book.author
        linkTextField.text = book.link
    }
    
}
