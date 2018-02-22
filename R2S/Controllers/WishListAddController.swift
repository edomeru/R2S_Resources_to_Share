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
    
    var selectedTags = [String : AnyObject]()
    var wishlistAdd = WishlistAdd()
    var checkboxCheck: Bool = false
    let validator = Validator()
    var subcategoryNames = [String]()
    var mainCategoryNames = [String]()
    var someDict = [String : AnyObject]()
    var subCategoryDictionary = [String : AnyObject]()
    var wishList = [WishListTags]()
    var myArray:[[String : Any]] = [[ : ]]
    var a = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUILayout()
        self.setupValidator()
        self.title = "Add New Wishlist"
        self.wishlistAdd.delegate = self
        
        //               someDict["main_category_name"] = "Industrial Spaces" as AnyObject
        //                someDict["main_category_id"] = 4 as AnyObject
        //                someDict["subcategory_name"] = "Container Yard" as AnyObject
        //                someDict["subcategory_id"] = 23 as AnyObject
        //
        //                WishListService.createWishlist(category: someDict , name: "Lizard", description: "black") { statusCode, message in
        //                    print("WISH CODE",statusCode)
        //                    print("WISH MSG",message)
        //
        //                }
        
        self.wishlistAdd.mainCategory.isHidden = true
        self.wishlistAdd.subCategoryCustom.isHidden = true
        
        
        
    }
    
    private func initUILayout() {
        self.wishlistAdd = self.loadFromNibNamed(nibNamed: Constants.xib.wishlistAddView) as! WishlistAdd
        self.view = self.wishlistAdd
        
        
        self.wishlistAdd.Description.delegate = self
        self.wishlistAdd.Name.delegate = self
        
        
        //self.wishlistAdd.categoryUITextField.delegate = self
        
        self.wishlistAdd.categorySearchTextField.addTarget(self, action: #selector(WishlistAddViewController.getSubCatWithHeadersSuggestions), for: UIControlEvents.editingDidBegin)
        
        self.wishlistAdd.mainCategory.addTarget(self, action: #selector(WishlistAddViewController.getMainCatOnlySuggestions), for: UIControlEvents.editingDidBegin)
        
        self.wishlistAdd.CategoryTagListView.delegate = self
        
        self.wishlistAdd.CategoryTagListView.cornerRadius = 5.5
        
        self.wishlistAdd.checkboxUICCheckbox.delegate = self
        
        
        
        
        
        
    }
    
    func getMainCatOnlySuggestions() {
        
        
        
        // Start visible even without user's interaction as soon as created - Default: false
        self.wishlistAdd.categorySearchTextField.startVisibleWithoutInteraction = true
        self.wishlistAdd.mainCategory.startVisibleWithoutInteraction = true
        // Set data source
        self.wishlistAdd.categorySearchTextField.startVisible = true
        
        
        
        self.wishlistAdd.categorySearchTextField.theme.bgColor = UIColor.white
        self.wishlistAdd.mainCategory.theme.bgColor = UIColor.white
        
        
        // Show loading indicator
        self.wishlistAdd.categorySearchTextField.showLoadingIndicator()
        
        
        // TODO: optimize
        let categoryTuples = self.getAllCscsid()
        print("ALL SUGGESTIONS", categoryTuples)
        print("SUB SUGGESTIONS", categoryTuples?.sub)
        print("MAIN SUGGESTIONS", categoryTuples?.main)

        // TODO:
        // add Main category, no select event
        // main category, subcategory group
        
        
        print("MAIN vjcgjcc")
        self.wishlistAdd.mainCategory.filterStrings((categoryTuples?.main)!)
        
        self.wishlistAdd.mainCategory.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.wishlistAdd.mainCategory.text = item.title
            
        }
        
        // Stop loading indicator
        self.wishlistAdd.categorySearchTextField.stopLoadingIndicator()
        
        
        
        
        
        
        
        
    }
    
    
    func getSubCatWithHeadersSuggestions() {
        // Start visible even without user's interaction as soon as created - Default: false
        self.wishlistAdd.categorySearchTextField.startVisibleWithoutInteraction = true
        self.wishlistAdd.mainCategory.startVisibleWithoutInteraction = true
        // Set data source
        self.wishlistAdd.categorySearchTextField.startVisible = true
        
        
        
        self.wishlistAdd.categorySearchTextField.theme.bgColor = UIColor.white
        self.wishlistAdd.mainCategory.theme.bgColor = UIColor.white
        
        
        // Show loading indicator
        self.wishlistAdd.categorySearchTextField.showLoadingIndicator()
        
        // TODO optimize
        let categoryTuples = self.getAllCscsid()
        print("ALL SUGGESTIONS", categoryTuples)
        print("SUB SUGGESTIONS", categoryTuples?.sub)
        print("MAIN SUGGESTIONS", categoryTuples?.main)
        // TODO:
        // add Main category, no select event
        // main category, subcategory group
        self.wishlistAdd.categorySearchTextField.filterStrings((categoryTuples?.sub)!)
        
        self.wishlistAdd.categorySearchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            
            // TODO: check skip if main cat
            
            let item = filteredResults[itemPosition]
            self.wishlistAdd.CategoryTagListView.addTag(item.title)
            
            
        }
        
        // Stop loading indicator
        self.wishlistAdd.categorySearchTextField.stopLoadingIndicator()
        
    }
    // TODO
    fileprivate func getAllCscsid() -> (main: [String], sub: [String], combined: [String])? {
        
        
        let categories =  CategoryService.getCategories()
        self.wishlistAdd.categorySearchTextField.showLoadingIndicator()
        for category in categories {
            print("CATEGORIES IDS",category.id)
            print("CATEGORIES NAME",category.name)
            mainCategoryNames.append(category.name)
            
            let subcategories =  CategoryService.getSubcategoriesBy(categoryId: category.id)
            for subcategory in subcategories {
                print("SUBCATEGORIES" + "\(subcategory.name )" + "\(subcategory.id)" + " " + "\(subcategory.parentCategory?.name)" + "\(subcategory.parentCategory?.id)" )
                
                subcategoryNames.append(subcategory.name)
                
                let wishlistTags =  WishListTags()
                wishlistTags.id = IncrementaID()
                wishlistTags.main_category_name = (subcategory.parentCategory?.name)!
                wishlistTags.main_category_id = (subcategory.parentCategory?.id)!
                wishlistTags.subcategory_name = (subcategory.name)
                wishlistTags.subcategory_id = (subcategory.id)
                
                WishListDao.addWishListFromTags(wishlistTags)
                
            }
            
        }
        
        return (mainCategoryNames, subcategoryNames)
    }
    
    //Increment ID
    public func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(WishListTags.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        }else{
            return 1
        }
    }
    
    private func setupValidator() {
        self.validator.registerField(self.wishlistAdd.Description, rules: [RequiredRule()])
        self.validator.registerField(self.wishlistAdd.Name, rules: [RequiredRule()])
    }
    
    
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        self.wishlistAdd.CategoryTagListView.removeTagView(tagView)
        
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
        self.validator.validate(self)
        
        
    }
    func checkBoxTicked(sender: AnyObject){
        print("checkBoxTicked")
        
    }
}

//MARK - ValidationDelegate
extension WishlistAddViewController: ValidationDelegate {
    func validationSuccessful() {
        if Reachability.isConnectedToNetwork() {
            
            let name = self.wishlistAdd.Name.text!
            let desc = self.wishlistAdd.Description.text!
            
            //print("PRINT TAGLABEL",self.wishlistAdd.CategoryTagListView.tagViews.first?.titleLabel?.text)
            print("self.wishlistAdd.CategoryTagListView.tagViews.count",self.wishlistAdd.CategoryTagListView.tagViews.count)
            for wish in self.wishlistAdd.CategoryTagListView.tagViews {
                
                print("index",wish.titleLabel?.text)
                
                print( "Metal Cutter SUB",WishListDao.getWishListFromTags(subcategory_name: "Metal Cutter"))
                print("TAGVIEWS",self.wishlistAdd.CategoryTagListView.tagViews.last?.titleLabel?.text)
                let selctedCategories =  WishListDao.getWishListFromTags(subcategory_name: (wish.titleLabel?.text)!)
                
                let wishAdd = WishListTags()
                for  categories  in selctedCategories {
                    
                    // selectedTags["main_category_name"] = categories.main_category_name as AnyObject
                    selectedTags["main_category_id"] = categories.main_category_id as AnyObject
                    selectedTags["subcategory_id"] = categories.subcategory_id as AnyObject
                    //wishAdd.main_category_id = categories.main_category_id
                    //selectedTags["subcategory_name"] = categories.subcategory_name as AnyObject
                    //wishAdd.subcategory_id = categories.subcategory_id
                    
                    // wishList.append(wishAdd)
                    
                    
                }
                
                a.addObjects(from: [selectedTags as! Any])
                
            }
            
            print("SLECTED TAGS",a)
            SwiftSpinner.show("Please wait..")
            WishListService.createWishlist(category: a , name: name, description: desc) { statusCode, message in
                
                print("STATUS CODE",statusCode)
                if statusCode! == 201 {
                    //                    WishListService.getAllWishList(onCompletion: { statusCode, message in
                    SwiftSpinner.hide()
                    //                        print("STATUS CODE2",statusCode)
                    //                         if statusCode! == 200 {
                    // let wishList = WishListDao.get()
                    //                    self.performSegue(withIdentifier: Constants.segue.loginToHome, sender: self)
                    // print("WISHLIST ADDED SUCCESSFULLY", wishList)
                    NotificationCenter.default.post(name: Notification.Name(rawValue:"pass"), object: nil, userInfo: nil)
                    self.navigationController?.popViewController(animated: true)
                    //                        }
                    //                    }
                    //                    )
                } else {
                    Utility.showAlert(title: "Login Error", message: message!, targetController: self)
                }
            }
        } else {
            Utility.showAlert(title: "", message: "No internet connection.", targetController: self)
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, _) in errors {
            if let field =  field as? UITextField {
                switch field {
                case self.wishlistAdd.Description:
                    self.wishlistAdd.Description.backgroundColor = UIColor.red
                case self.wishlistAdd.Name:
                    self.wishlistAdd.Name.backgroundColor = UIColor.red
                default:
                    print("default")
                }
            }
        }
    }
}


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

extension WishlistAddViewController: CheckboxDelegate {
    func didSelect(_ checkbox: CCheckbox) {
        switch checkbox {
        case self.wishlistAdd.checkboxUICCheckbox:
            print("checkbox one selected")
            checkboxCheck = true
            self.wishlistAdd.categorySearchTextField.isHidden = true
            self.wishlistAdd.CategoryTagListView.isHidden = true
            self.wishlistAdd.mainCategory.isHidden = false
            self.wishlistAdd.subCategoryCustom.isHidden = false
            break
            
        default:
            break
        }
    }
    
    func didDeselect(_ checkbox: CCheckbox) {
        switch checkbox {
        case self.wishlistAdd.checkboxUICCheckbox:
            print("checkbox one deselected")
            checkboxCheck = false
            self.wishlistAdd.categorySearchTextField.isHidden = false
            self.wishlistAdd.CategoryTagListView.isHidden = false
            self.wishlistAdd.mainCategory.isHidden = true
            self.wishlistAdd.subCategoryCustom.isHidden = true
            break
            
        default:
            break
        }
    }
}


