//
//  AnimViewController.swift
//  BookMe
//
//  Created by Woxapp on 25.11.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class AnimViewController: UIViewController {

    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimate()
    }
    
    private func startAnimate() {
        UIView.animate(withDuration: 0.7) {
            self.backgroundImageView.alpha = 0
            self.nameLabel.textColor = Session.tintColor
        }
        bottomSpace.constant = 30
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .transitionFlipFromTop, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.perform(#selector(self.segue), with: nil, afterDelay: 0.5)
        })
    }
    
    @objc private func segue() {
        performSegue(withIdentifier: "tabbar", sender: nil)
    }
    
}
