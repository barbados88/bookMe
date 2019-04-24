//
//  BookNewCell.swift
//  BookMe
//
//  Created by mac on 28.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class BookNewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradientView: UIView?
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel?
    
    var book : Book? = nil
    var history : Bool = false
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        book?.addToFavourite()
    }
    
    func configureWith(_ b : Book) {
        addGradient()
        book = b
        favouriteButton.isSelected = b.isFavourite
        iconImageView.image = b.icon
        nameLabel.text = b.bookName
        descriptionLabel.text = b.bookAuthor
        aboutLabel?.text = history == true ? b.readTime : b.bookDescription
    }
    
    func addGradient() {
        removeGradient()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView?.bounds ?? CGRect.zero
        gradientLayer.colors = [UIColor.clear.cgColor, Session.tintColor.cgColor]
        gradientView?.layer.addSublayer(gradientLayer)
    }
    
    func removeGradient() {
        if let layers = gradientView?.layer.sublayers {
            for layer in layers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
}
