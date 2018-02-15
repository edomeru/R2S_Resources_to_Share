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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        self.registerView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.registerView.frame.width, height: self.registerView.frame.height)
        self.view = self.registerView
            
        self.title = "Registration"
        self.registerView.delegate = self
        self.registerView.firstNameTextField.delegate = self
        self.registerView.lastNameTextField.delegate = self
        self.registerView.emailTextField.delegate = self
        self.registerView.passwordTextField.delegate = self
        self.registerView.confirmPasswordTextField.delegate = self
        self.registerView.businessREgNumberTextField.delegate = self
        self.registerView.companyNameTextField.delegate = self
    }
    
    private func setupValidator() {
        self.validator.registerField(self.registerView.firstNameTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.lastNameTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.emailTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.passwordTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.confirmPasswordTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.businessREgNumberTextField, rules: [RequiredRule()])
        self.validator.registerField(self.registerView.companyNameTextField, rules: [RequiredRule()])
    }
    
    private func configureNavBar() {
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - RegisterViewDelegate
extension RegisterViewController: RegisterViewDelegate {
    func registerButtonPressed(sender: AnyObject) {
        self.registerView.endEditing(true)
        self.validator.validate(self)
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
            if let field =  field as? UITextField {
                switch field {
                case self.registerView.firstNameTextField:
                    self.registerView.firstNameBorderView.backgroundColor = UIColor.red
                case self.registerView.lastNameTextField:
                    self.registerView.lastNameBorderView.backgroundColor = UIColor.red
                case self.registerView.emailTextField:
                    self.registerView.emailBorderView.backgroundColor = UIColor.red
                case self.registerView.passwordTextField:
                    self.registerView.passwordBorderView.backgroundColor = UIColor.red
                case self.registerView.confirmPasswordTextField:
                    self.registerView.confirmPasswordBorderView.backgroundColor =  UIColor.red
                case self.registerView.companyNameTextField:
                    self.registerView.companyBorderView.backgroundColor =  UIColor.red                case self.registerView.businessREgNumberTextField:
                    self.registerView.busnessRegBorderView.backgroundColor = UIColor.red
                default:
                    print("default")
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.registerView.firstNameTextField:
            self.registerView.firstNameBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.registerView.lastNameTextField:
            self.registerView.lastNameBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.registerView.emailTextField:
            self.registerView.emailBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.registerView.passwordTextField:
            self.registerView.passwordBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.registerView.confirmPasswordTextField:
            self.registerView.confirmPasswordBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.registerView.companyNameTextField:
            self.registerView.companyBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        case self.registerView.businessREgNumberTextField:
            self.registerView.busnessRegBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
        default:
            print("default")
        }
    }
}
