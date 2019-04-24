//
//  AuthViewController.swift
//  BookMe
//
//  Created by mac on 20.01.17.
//  Copyright © 2017 woxapp. All rights reserved.
//

import UIKit
import MessageUI

class AuthViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tapView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSettings()
        startSettings()
    }
    
    //MARK - UITextField methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextField.becomeFirstResponder()
        } else {
            authInApp(nil)
        }
        return false
    }
    
    //MARK - Actions
    
    @IBAction func authInApp(_ sender: Any?) {
        if isValidFields == false { return}
        addActivity()
        Communicator.authInApp(completion: {[weak self] success in
            guard let wself = self else {return}
            if success == true {
                wself.performSegue(withIdentifier: "auth", sender: nil)
            }
            self?.removeActivity(animated: true)
        })
    }
    
    @IBAction func support(_ sender: Any) {
        configureMailComposer()
    }
    
    //MARK - Helper methods
    
    private func configureMailComposer() {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setToRecipients(["support@woxapp.com"])
        vc.setSubject(NSLocalizedString("У меня нет аккаунта", comment:""))
        if MFMailComposeViewController.canSendMail() {
            present(vc, animated: true, completion: nil)
        }
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    private func navBarSettings() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func startSettings() {
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.singleTap)))
    }
    
    @objc private func singleTap() {
        self.view.endEditing(true)
    }
    
    private var isValidFields : Bool {
        self.view.endEditing(true)
        if Utils.isValidMail(mailTextField.text) == false {
            mailTextField.shake()
            mailTextField.becomeFirstResponder()
            return false
        }
        if Utils.validatePassword(passwordTextField.text) == false {
            passwordTextField.shake()
            passwordTextField.becomeFirstResponder()
            return false
        }
        Session.mail = mailTextField.text!
        Session.password = passwordTextField.text!
        return true
    }
    
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.view.endEditing(true)
        if segue.identifier == "recover" {
            let vc = segue.destination as? RecoverViewController
            vc?.mail = mailTextField.text
        }
    }

    @IBAction func unwindAuth(_ segue: UIStoryboardSegue) { }
    
}
