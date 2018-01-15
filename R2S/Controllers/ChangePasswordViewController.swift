//
//  ChangePasswordViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftValidator

class ChangePasswordViewController: BaseViewController {
    
    var changePasswordView = ChangePasswordView()
    var params = [String : Any]()
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUILayout()
        self.setupValidator()
        self.title = "Change Password"
        
    }
    
    private func initUILayout() {
        
        self.changePasswordView = self.loadFromNibNamed(nibNamed: Constants.xib.ChangePasswordView) as! ChangePasswordView
        self.changePasswordView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        self.changePasswordView.delegate = self
    self.changePasswordView.submitUIBUttonOutlet.backgroundColor = UIColor(hexString: Constants.color.primary)
        self.changePasswordView.submitUIBUttonOutlet.setTitleColor(UIColor.white, for: .normal) 
        self.view.addSubview(self.changePasswordView)
        
    }
    
    private func setupValidator() {
        self.validator.registerField(self.changePasswordView.changePasswordUITextField, rules: [RequiredRule()])
        self.validator.registerField(self.changePasswordView.newPasswordUITextField, rules: [RequiredRule()])
        self.validator.registerField(self.changePasswordView.confirmNewPasswordUITextField, rules: [RequiredRule()])
       
    }

    
    func alertConfirmation(title: String, message:String) {
        
        let dialogMessage = UIAlertController(title: title , message: message , preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
           
            self.changePassword()
            
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
        
    }
    
    
  private func changePassword() {
    
    SwiftSpinner.show("Please wait...")
    params["old_password"] =  self.changePasswordView.changePasswordUITextField.text!
    params["password"]  = self.changePasswordView.newPasswordUITextField.text!
    params["confirm_password"]  =  self.changePasswordView.confirmNewPasswordUITextField.text!
    
    
    print("CPW_PARAM",params)
    
    AccountService.changePassword(params: params as [String : Any]) { statusCode, message in
        SwiftSpinner.hide()
        let defaults = UserDefaults.standard
        defaults.setValue(self.changePasswordView.newPasswordUITextField.text!, forKey: "password")
        
        print("STATUS CODE",statusCode)
        if statusCode == 202 {
            
            
            self.navigationController?.popViewController(animated: true)
            Utility.showSnackBAr(messege:"Password has been changed Succesfully", bgcolor: UIColor(hexString: Constants.color.greenSnackBar)!)
            
        } else {
            Utility.showAlert(title: "Login Error", message: message!, targetController: self)
        }
    }

    
    
    }
    
}


extension ChangePasswordViewController: ChangePasswordViewDelegate {
    
    func submitButtonPressed
        (sender: AnyObject){
        
        self.changePasswordView.endEditing(true)
        self.validator.validate(self)
        
        

    }
}

//MARK - ValidationDelegate
extension ChangePasswordViewController: ValidationDelegate {
    func validationSuccessful() {
    
        alertConfirmation(title: "Confirm", message:"Are you sure you want to change your password?")
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }        }
}

