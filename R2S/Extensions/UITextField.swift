//
//  UITextField.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

extension UITextField {
    func textFieldAddBottomBorder(textField: UITextField, borderValue: CGFloat, borderColor: String) {
        let border = CALayer()
        let width = borderValue
        border.borderColor = UIColor(hex: borderColor).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func setKBType(type: UIKeyboardType) {
        self.keyboardType = type
    }
    
    func addLeftPadding(paddingValue: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingValue, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
    }
}
