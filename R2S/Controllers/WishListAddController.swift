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
import Foundation
import TagListView

class WishlistAddViewController: BaseViewController, TagListViewDelegate {
    
    var wishlistAdd = WishlistAdd()
    let validator = Validator()
    var subcategoryNames = [String]()
     var someDict = [String : AnyObject]()
    var subCategoryDictionary = [String : AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        initUILayout()
        self.setupValidator()
        self.title = "Add New Wishlist"
        self.wishlistAdd.delegate = self
               someDict["main_category_name"] = "Guns" as AnyObject
                someDict["main_category_id"] = 5 as AnyObject
                someDict["subcategory_name"] = "silver bullet" as AnyObject
                someDict["subcategory_id"] = 5 as AnyObject
        
                WishListService.createWishlist(category: someDict , name: "Dove", description: "white") { statusCode, message in
                    print("WISH CODE",statusCode)
                    print("WISH MSG",message)
        
                }
        
        
        
        
        
        
    }
    
    private func initUILayout() {
        self.wishlistAdd = self.loadFromNibNamed(nibNamed: Constants.xib.wishlistAddView) as! WishlistAdd
        self.view = self.wishlistAdd
        
        
        self.wishlistAdd.Description.delegate = self
        self.wishlistAdd.Name.delegate = self
        
        
        self.wishlistAdd.categoryUITextField.delegate = self
        
        self.wishlistAdd.categorySearchTextField.addTarget(self, action: Selector("configureSimpleSearchTextField"), for: UIControlEvents.editingDidBegin)
        
        
        self.wishlistAdd.CategoryTagListView.delegate = self
        
        
        
        
        self.wishlistAdd.CategoryTagListView.addTag("TagListView")
        self.wishlistAdd.CategoryTagListView.addTag("TEAChart")
        self.wishlistAdd.CategoryTagListView.addTag("To Be Removed")
        self.wishlistAdd.CategoryTagListView.addTag("To Be Removed")
        self.wishlistAdd.CategoryTagListView.addTag("Quark Shell")
        self.wishlistAdd.CategoryTagListView.removeTag("To Be Removed")
        
        
        self.wishlistAdd.CategoryTagListView.addTag("TAG TO BE REMOVED").onTap = { [weak self] tagView in
            self?.wishlistAdd.CategoryTagListView.removeTagView(tagView)
            self?.wishlistAdd.categoryUITextField.addSubview(tagView)
        }
        
        
        
        
        
        //self.wishlistAdd.CategoryTagListView.frame = self.wishlistAdd.categoryUITextField.frame
        
        
        
        
    }
    
    func configureSimpleSearchTextField() {
        // Start visible even without user's interaction as soon as created - Default: false
        self.wishlistAdd.categorySearchTextField.startVisibleWithoutInteraction = true
        // Set data source
        self.wishlistAdd.categorySearchTextField.startVisible = true
        let countries = getAllCscsid()
         print("categories configureSimpleSearchTextField", countries)
          self.wishlistAdd.categorySearchTextField.filterStrings(countries)
        
        self.wishlistAdd.categorySearchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
             self.wishlistAdd.CategoryTagListView.addTag(item.title)
        }
        
        
    }
    
    fileprivate func getAllCscsid() -> [String] {
        
        
        let categories =  CategoryService.getCategories()
        
        for category in categories {
            print("CATEGORIES IDS",category.id)
            let subcategories =  CategoryService.getSubcategoriesBy(categoryId: category.id)
            for subcategory in subcategories {
                print("SUBCATEGORIES" + "\(subcategory.name )" + "\(subcategory.id)" + " " + "\(subcategory.parentCategory?.name)" + "\(subcategory.parentCategory?.id)" )
                
                subcategoryNames.append(subcategory.name)
            }
            
        }
        return subcategoryNames
    }
    
    private func setupValidator() {
        self.validator.registerField(self.wishlistAdd.Description, rules: [RequiredRule()])
        self.validator.registerField(self.wishlistAdd.Name, rules: [RequiredRule()])
    }
    
    
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
    
    
    func performAction() {
        
        self.wishlistAdd.CategoryTagListView.addTag(self.wishlistAdd.categoryUITextField.text!)
        
        
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        print("textFieldShouldReturn")
        performAction()
        textField.resignFirstResponder()
        return true
    }
}



