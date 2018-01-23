//
//  NewResourceView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 1/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import SearchTextField
import TagListView


protocol NewResourceViewDelegate: class {
    
    func submitButtonPressed(sender: AnyObject)
    
}

class NewResourceView: BaseUIView {
    weak var delegate: NewResourceViewDelegate?
    @IBOutlet weak var descErrorLine: UIView!
    
    @IBOutlet weak var CategoryTagListView: TagListView!
    
    @IBOutlet weak var rateUITextField: UITextField!
    
    @IBOutlet weak var priceErrorLine: UIView!
    @IBOutlet weak var quantityErrorLine: UIView!
    @IBOutlet weak var nameErrorLine: UIView!
 
    @IBOutlet weak var rateErrorLine: UIView!
    @IBOutlet weak var subCategoryUItextField: SearchTextField!
 
    @IBOutlet weak var addPhotoUIImageView: UIImageView!
    
    @IBOutlet weak var mainCategoryUISearchTextField: SearchTextField!
    
    @IBAction func submitUIButton(_ sender: Any) {
        
        delegate?.submitButtonPressed(sender: sender as AnyObject)
    }
    
    @IBOutlet weak var zipcodeUITextField: UITextField!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
   
    @IBOutlet weak var nameOfResourceUILable: UITextField!
    @IBOutlet weak var descriptionUILabel: UITextField!
    
    @IBOutlet weak var quantityUITextField: UITextField!
    
    
    @IBOutlet weak var priceUITextField: UITextField!
    
   
    @IBOutlet weak var checkBoxUIButton: CCheckbox!
    
    @IBOutlet weak var streetUITextField: UITextField!
    
    
    @IBOutlet weak var stateUITextField: UITextField!
    @IBOutlet weak var cityUITextField: UITextField!
    
}
