//
//  WishListAddController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 7/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftValidator
import SwiftSpinner

class WishlistAddViewController: BaseViewController {
    
 var wishlistAdd = WishlistAdd()
 let validator = Validator()
    //var someDict = [String : AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //initUILayout()
         //self.setupValidator()
        self.title = "Add New Wishlist"
//      self.wishlistAdd.delegate = self
//       someDict["main_category_name"] = "Utensils" as AnyObject
//        someDict["main_category_id"] = 5 as AnyObject
//        someDict["subcategory_name"] = "cup" as AnyObject
//        someDict["subcategory_id"] = 5 as AnyObject
//        
//        WishListService.createWishlist(category: someDict , name: "knife", description: "shiny") { statusCode, message in
//            print("WISH CODE",statusCode)
//            print("WISH MSG",message)
//            
//        }
        
    }

    private func initUILayout() {
        self.wishlistAdd = self.loadFromNibNamed(nibNamed: Constants.xib.wishlistAddView) as! WishlistAdd
        self.view = self.wishlistAdd
        
        
        self.wishlistAdd.Description.delegate = self
        self.wishlistAdd.Name.delegate = self
    }

    private func setupValidator() {
        self.validator.registerField(self.wishlistAdd.Description, rules: [RequiredRule()])
        self.validator.registerField(self.wishlistAdd.Name, rules: [RequiredRule()])
    }

}


// MARK: - LoginViewDelegate
extension WishlistAddViewController: WishlistAddViewDelegate {
    func submitButtonOnPressed(sender: AnyObject){
        
       print("HELLLLOOOOOOOOO")
        self.wishlistAdd.endEditing(true)
        //self.validator.validate(self)
        
    }
}

// MARK - ValidationDelegate
//extension WishlistAddViewController: ValidationDelegate {
//    func validationSuccessful() {
//        if Reachability.isConnectedToNetwork() {
//            SwiftSpinner.show("Please wait...")
//            let name = self.wishlistAdd.Name.text!
//            let desc = self.wishlistAdd.Description.text!
//        
//            WishListService.createWishlist(category: self.fruits, name: name, description: desc) { statusCode, message in
//                SwiftSpinner.hide()
//                if statusCode == 200 {
////                    self.performSegue(withIdentifier: Constants.segue.loginToHome, sender: self)
//                    print("WISHLIST ADDED SUCCESSFULLY")
//                    
//                } else {
//                    Utility.showAlert(title: "Login Error", message: message!, targetController: self)
//                }
//            }
//        } else {
//            Utility.showAlert(title: "", message: "No internet connection.", targetController: self)
//        }
//    }
//    
//    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
//        for (field, _) in errors {
//            if let field =  field as? UITextField {
//                switch field {
//                case self.wishlistAdd.Description:
//                   self.wishlistAdd.Description.backgroundColor = UIColor.red
//                case self.wishlistAdd.Name:
//                    self.wishlistAdd.Name.backgroundColor = UIColor.red
//                default:
//                    print("default")
//                }
//            }
//        }
//    }
//}


// MARK: - UITextFieldDelegate
extension WishlistAddViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.wishlistAdd.Description:
            print("wishlistAdd.Description")
            self.wishlistAdd.Description.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.wishlistAdd.Description.backgroundColor = UIColor.white
        case self.wishlistAdd.Name:
            print("wishlistAdd.Neme")
            self.wishlistAdd.Name.backgroundColor = UIColor(hex: Constants.color.grayUnderline)
            self.wishlistAdd.Name.backgroundColor = UIColor.white

        default:
            print("default")
        }
    }
}



