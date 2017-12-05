//
//  NewResourceView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 1/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit


protocol NewResourceViewDelegate: class {
    func submitButtonPressed(sender: AnyObject)
    
}

class NewResourceView: BaseUIView {
    weak var delegate: NewResourceViewDelegate?
    
    @IBOutlet weak var rateUITextField: UITextField!
    
 
 
    
    @IBAction func submitUIButton(_ sender: Any) {
        
        delegate?.submitButtonPressed(sender: sender as AnyObject)
    }
    
    
   
    
    
    
    
}
