//
//  RegisterView.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import M13Checkbox

protocol RegisterViewDelegate: class {
    func registerButtonPressed(sender: AnyObject)
}

class RegisterView: BaseUIView {
    weak var delegate: RegisterViewDelegate?
    @IBOutlet weak var companyNameTextField: UITextField!

    @IBOutlet weak var businessREgNumberTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var subscribeCheckbox: M13Checkbox!
    @IBOutlet weak var firstNameBorderView: UIView!
    @IBOutlet weak var lastNameBorderView: UIView!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var passwordBorderView: UIView!
    @IBOutlet weak var companyBorderView: UIView!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var busnessRegBorderView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var confirmPasswordBorderView: UIView!
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        delegate?.registerButtonPressed(sender: sender)
    }
}
