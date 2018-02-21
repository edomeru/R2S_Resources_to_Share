//
//  ForgotPasswordView.swift
//  R2S
//
//  Created by Vito Cuaderno on 2/21/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

protocol ForgotPassworViewDelegate: class {
    func submitBtnPressed(sender: UIButton)
}

class ForgotPasswordView: BaseUIView {
    weak var delegate: ForgotPassworViewDelegate?
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var emailBorderView: UIView!
    
    @IBOutlet weak var emailErrorMsg: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if (delegate != nil) {
            delegate?.submitBtnPressed(sender: sender)
        }
        
    }


}
