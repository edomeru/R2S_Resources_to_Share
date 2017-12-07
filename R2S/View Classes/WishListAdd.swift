//
//  WishListAdd.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 7/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit


protocol WishlistAddViewDelegate: class {
    func submitButtonOnPressed(sender: AnyObject)
    
}


class WishlistAdd: BaseUIView {
  weak var delegate: WishlistAddViewDelegate?
    
    @IBOutlet weak var Category: UITextField!
    
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var Description: UITextField!
 
    @IBAction func SubmitButton(_ sender: Any) {
        
        delegate?.submitButtonOnPressed(sender: sender as AnyObject)
    }
    
}
