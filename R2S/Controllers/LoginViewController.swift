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
        self.loginView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.loginView.frame.width, height: self.loginView.frame.height)
        self.view = self.loginView
        
        
        self.loginView.delegate = self
        self.loginView.emailTextField.delegate = self
        self.loginView.passwordTextField.delegate = self
        self.loginView.emailTextField.text = "clarissa@tirsolutions.com"
        self.loginView.passwordTextField.text = "Clang.23"
    }
    
    // MARK: - Private Functions
    
    private func setupValidator() {
        self.validator.registerField(self.loginView.emailTextField, rules: [RequiredRule()])
        self.validator.registerField(self.loginView.passwordTextField, rules: [RequiredRule()])
    }
    
    private func configureNavBar() {
        self.title = "Login"
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func loginButtonPressed(sender: AnyObject) {
        self.loginView.endEditing(true)
        self.validator.validate(self)
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
            
//         let username =  "\(venjo_villeza@yahoo.com)"
//          let  password =  "\(password)"
            
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
                switch field {
                case self.loginView.emailTextField:
                    self.loginView.emailBorderView.backgroundColor = UIColor.red
                case self.loginView.passwordTextField:
                    self.loginView.passwordBorderView.backgroundColor = UIColor.red
                default:
                    print("default")
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.loginView.emailTextField:
            self.loginView.emailBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.loginView.passwordTextField:
            self.loginView.passwordBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        default:
            print("default")
        }
    }
}
