//
//  EditInfoViewController.swift
//  BookMe
//
//  Created by mac on 04.02.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class EditInfoViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeInfo(_ sender: Any) {
        
    }
    

}
