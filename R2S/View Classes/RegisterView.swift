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
    func cancelButtonPressed(sender: AnyObject)
    func registerButtonPressed(sender: AnyObject)
}

class RegisterView: BaseUIView {
    weak var delegate: RegisterViewDelegate?

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var subscribeCheckbox: M13Checkbox!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        delegate?.cancelButtonPressed(sender: sender)
    }
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        delegate?.registerButtonPressed(sender: sender)
    }
}
