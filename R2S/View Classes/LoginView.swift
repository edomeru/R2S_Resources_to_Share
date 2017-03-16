//
//  LoginView.swift
//  R2S
//
//  Created by Earth Maniebo on 14/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
    func loginButtonPressed(sender: AnyObject)
    func registerButtonPressed(sender: AnyObject)
    func forgotPasswordButtonPressed(sender: AnyObject)
}

class LoginView: BaseUIView {
    weak var delegate: LoginViewDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        delegate?.loginButtonPressed(sender: sender)
    }
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        delegate?.registerButtonPressed(sender: sender)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: AnyObject) {
        delegate?.forgotPasswordButtonPressed(sender: sender)
    }
}
