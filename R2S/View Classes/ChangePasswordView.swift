//
//  ChangePasswordView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

protocol ChangePasswordViewDelegate: class {
    
    func submitButtonPressed(sender: AnyObject)
    
}


class ChangePasswordView: BaseUIView {
     weak var delegate: ChangePasswordViewDelegate?

    @IBOutlet weak var changePasswordUITextField: UITextField!
    
    @IBOutlet weak var newPasswordUITextField: UITextField!
    
    @IBOutlet weak var confirmNewPasswordUITextField: UITextField!
    
    @IBOutlet weak var submitUIBUttonOutlet: UIButton!
    
    @IBAction func submitUIButton(_ sender: Any) {
        delegate?.submitButtonPressed(sender: sender as AnyObject)
        
    }
    
}
