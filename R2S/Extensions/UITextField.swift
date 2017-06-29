//
//  UITextField.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

extension UITextField {
    func addBottomBorder(borderValue: CGFloat, borderColor: String) {
        let border = CALayer()
        let width = borderValue
        border.borderColor = UIColor(hex: borderColor).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
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
