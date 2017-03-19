//
//  LoginViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 14/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import SwiftValidator
import SwiftSpinner

class LoginViewController: BaseViewController {

    var loginView = LoginView()
    var activeTextField = UITextField()
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        self.setupValidator()
        if UserManager.sharedInstance.isLoggedIn! {
            self.performSegue(withIdentifier: Constants.segue.loginToHome, sender: self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.configureNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Functions
    private func initUILayout() {
        self.loginView = self.loadFromNibNamed(nibNamed: Constants.xib.login) as! LoginView
        self.view = self.loginView
        self.loginView.delegate = self
        self.loginView.emailTextField.delegate = self
        self.loginView.passwordTextField.delegate = self
    }
    
    private func setupValidator() {
        self.validator.registerField(self.loginView.emailTextField, rules: [RequiredRule()])
        self.validator.registerField(self.loginView.passwordTextField, rules: [RequiredRule()])
    }
    
    private func configureNavBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginButtonPressed(sender: AnyObject) {
        self.loginView.endEditing(true)
        self.validator.validate(self)
    }
    
    func registerButtonPressed(sender: AnyObject) {
        
    }
    
    func forgotPasswordButtonPressed(sender: AnyObject) {
        
    }
}

// MARK - ValidationDelegate
extension LoginViewController: ValidationDelegate {
    func validationSuccessful() {
        if Reachability.isConnectedToNetwork() {
            SwiftSpinner.show("Logging in...")
            let username = self.loginView.emailTextField.text!
            let password = self.loginView.passwordTextField.text!
            
            UserService.login(email: username, password: password) { statusCode, message in
                SwiftSpinner.hide()
                if statusCode == 200 {
                    self.performSegue(withIdentifier: Constants.segue.loginToHome, sender: self)
                } else {
                    Utility.showAlert(title: "Login Error", message: message!, targetController: self)
                }
            }
        } else {
            Utility.showAlert(title: "", message: "No internet connection.", targetController: self)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, _) in errors {
            if let field =  field as? UITextField {
                field.addBorder(width: 1.0, color: UIColor.red.cgColor, radius: 4.0)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addBorder(width: 0.0, radius: 0.0)
        self.activeTextField = textField
    }
}
