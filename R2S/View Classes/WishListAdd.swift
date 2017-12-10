//
//  WishListAdd.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 7/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import TagListView
import SearchTextField

protocol WishlistAddViewDelegate: class {
    func submitButtonOnPressed(sender: AnyObject)
    
}


class WishlistAdd: BaseUIView {
  weak var delegate: WishlistAddViewDelegate?
    
    @IBOutlet weak var categoryUITextField: UITextField!
   
    @IBOutlet weak var CategoryTagListView: TagListView!
    
    @IBOutlet weak var Name: UITextField!
    
    @IBOutlet weak var Description: UITextField!
 
    @IBAction func SubmitButton(_ sender: Any) {
        
        delegate?.submitButtonOnPressed(sender: sender as AnyObject)
    }
    
    @IBOutlet weak var categorySearchTextField: SearchTextField!
}
