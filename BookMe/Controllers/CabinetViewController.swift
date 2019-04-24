//
//  CabinetViewController.swift
//  BookMe
//
//  Created by mac on 21.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class CabinetViewController: UIViewController {

    
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.fifth), name: .fifthTab, object: nil)
        userInfo()
    }

    //MARK - Actions
    
    @IBAction func change(_ sender: Any) {
        performSegue(withIdentifier: "change", sender: nil)
    }
    
    //MARK - Helper methods
    
    func userInfo() {
        nameLabel.text = Session.name
        surnameLabel.text = Session.surname
        mailLabel.text = Session.mail
    }
    
}
