//
//  EditProfileView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

protocol EditProfileViewDelegate: class {
    func submitButtonPressed(sender: AnyObject)
}


class EditProfileView: BaseUIView {
    weak var delegate: EditProfileViewDelegate?
    
    @IBOutlet weak var profPicUIImageView: UIImageView!
    
    @IBOutlet weak var bioUITextView: UITextView!
    
    @IBOutlet weak var firstNameUITextField: UITextField!
    
    @IBOutlet weak var lastNameUITextField: UITextField!
    
    @IBOutlet weak var companyUITextField: UITextField!
    
    @IBOutlet weak var designationUITextField: UITextField!
    
    @IBOutlet weak var birthdayUITextField: UITextField!
   
    @IBOutlet weak var mobileUITextField: UITextField!
    
    @IBOutlet weak var landlineUITextField: UITextField!
    
    @IBAction func saveUIButton(_ sender: AnyObject) {
        delegate?.submitButtonPressed(sender: sender)
    }
    
    
}
