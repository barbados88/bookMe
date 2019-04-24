//
//  RecoverViewController.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit

class RecoverViewController: UIViewController, UIGestureRecognizerDelegate {

    var mail : String? = nil
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var tapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK - Actions
    @IBAction func recover(_ sender: Any) {
        if isValidFields == false {return}
        addActivity()
        Communicator.recoverPassword(completion: {[weak self] response in
            self?.removeActivity(animated: true)
            if response == false {return}
            ServerError.stringError(code: 782)
            self?.navigationController?.popViewController(animated: true)
        })
    }

    //MARK - Helper methods 
    
    @objc private func singleTap() {
        self.view.endEditing(true)
    }
    
    private var isValidFields : Bool {
        if Utils.isValidMail(mailTextField.text) == false {
            mailTextField.shake()
            mailTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    private func startSettings() {
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.singleTap)))
        mailTextField.text = mail
    }
    
}
