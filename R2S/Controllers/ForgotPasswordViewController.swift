//
//  ForgotPasswordViewController.swift
//  R2S
//
//  Created by Vito Cuaderno on 2/21/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import SwiftSpinner

class ForgotPasswordViewController: BaseViewController {
    
    var forgotPasswordView = ForgotPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private Functions
    private func initUILayout() {
        // TODO: BaseUIController initUILayout BaseView param
        self.forgotPasswordView = self.loadFromNibNamed(nibNamed: Constants.xib.forgotPassword) as! ForgotPasswordView
        self.forgotPasswordView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.forgotPasswordView.frame.width, height: self.forgotPasswordView.frame.height)
        self.view = self.forgotPasswordView
        
        
        self.forgotPasswordView.delegate = self
        self.forgotPasswordView.emailField.delegate = self
    }
    
    
}


// MARK: - LoginViewDelegate
extension ForgotPasswordViewController: ForgotPassworViewDelegate {
    func isValidEmail(testStr:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func submitBtnPressed(sender: UIButton) {
        
        let email = self.forgotPasswordView.emailField.text
        
        // VALIDATE
        if (!isValidEmail(testStr: email)) {
            self.forgotPasswordView.emailErrorMsg.text = "Invalid email."
            self.forgotPasswordView.emailBorderView.backgroundColor = UIColor.red
            return
        }
        
        // SEND REQUEST
        UserService.forgot(email: email!, onCompletion: { statusCode, message in
            SwiftSpinner.hide()
            if statusCode == 200 {
                Utility.showAlert(title: "Success!", message: message!, targetController: self)
            } else {
                self.forgotPasswordView.emailErrorMsg.text = message
                self.forgotPasswordView.emailBorderView.backgroundColor = UIColor.red
            }
            SwiftSpinner.hide()
            sender.isEnabled = true
        })
        // SET DISABLED
        sender.isEnabled = false
        // SET PROGRESS
        SwiftSpinner.show("Please wait...")
        
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.forgotPasswordView.emailErrorMsg.text = ""
        self.forgotPasswordView.emailBorderView.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
    }
}
