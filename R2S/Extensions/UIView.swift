//
//  UIView.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

extension UIView {
    func addBorder(width: CGFloat) {
        self.layer.borderWidth = width
    }
    
    func addBorder(color: CGColor) {
        self.layer.borderColor = color
    }
    
    func addBorder(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addBorder(width: CGFloat, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    
    func addBorder(width: CGFloat, radius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addBorder(color: CGColor, radius: CGFloat) {
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addBorder(width: CGFloat, color: CGColor, radius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
