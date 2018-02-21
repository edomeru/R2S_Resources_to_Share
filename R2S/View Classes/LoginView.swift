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
    func forgotPasswordButtonPressed(sender: AnyObject)
}

class LoginView: BaseUIView {
    weak var delegate: LoginViewDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var passwordBorderView: UIView!
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        delegate?.loginButtonPressed(sender: sender)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: AnyObject) {
        delegate?.forgotPasswordButtonPressed(sender: sender)
    }
}
