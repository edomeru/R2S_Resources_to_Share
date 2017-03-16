//
//  RegisterViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftValidator

class RegisterViewController: BaseViewController {
    var registerView = RegisterView()
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
        self.registerView = self.loadFromNibNamed(nibNamed: Constants.xib.register) as! RegisterView
        self.view = self.registerView
        self.title = "Registration"
        self.registerView.delegate = self
        self.registerView.firstNameTextField.delegate = self
        self.registerView.lastNameTextField.delegate = self
        self.registerView.emailTextField.delegate = self
        self.registerView.passwordTextField.delegate = self
    }
    
    private func setupValidator() {
        self.validator.registerField(self.registerView.firstNameTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.lastNameTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.emailTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.passwordTextField, rules: [RequiredRule()])
    }
    
    private func configureNavBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - RegisterViewDelegate
extension RegisterViewController: RegisterViewDelegate {
    func registerButtonPressed(sender: AnyObject) {
        self.registerView.endEditing(true)
        self.validator.validate(self)
    }
    
    func cancelButtonPressed(sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK: - ValidationDelegate
extension RegisterViewController: ValidationDelegate {
    func validationSuccessful() {
        if Reachability.isConnectedToNetwork() {
            SwiftSpinner.show("Registering...")
            let user = User()
            user.email = self.registerView.emailTextField.text!
            user.firstName = self.registerView.firstNameTextField.text!
            user.lastName = self.registerView.lastNameTextField.text!
            user.password = self.registerView.passwordTextField.text!
            if self.registerView.subscribeCheckbox.checkState == .checked {
                user.isSubscribed = true
            } else if self.registerView.subscribeCheckbox.checkState == .unchecked {
                user.isSubscribed = false
            }
            UserService.register(user, onCompletion: { statusCode, message in
                SwiftSpinner.hide()
                if statusCode == 201 {
                    Utility.showAlert(title: message!.capitalized, message: "Please check your email for the activation link and verify your account.", targetController: self)
                } else {
                    Utility.showAlert(title: "Registration Error", message: message!, targetController: self)
                }
            })
        } else {
            Utility.showAlert(title: "", message: "No internet connection.", targetController: self)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, _) in errors {
            if let field = field as? UITextField {
                field.addBorder(width: 1.0, color: UIColor.red.cgColor)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addBorder(width: 0.0, radius: 0.0)
        self.activeTextField = textField
    }
}
