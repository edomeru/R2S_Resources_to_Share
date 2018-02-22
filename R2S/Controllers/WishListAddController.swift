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
import SearchTextField

class WishlistAddViewController: BaseViewController, TagListViewDelegate {
    
    var selectedTags = [String : AnyObject]()
    var wishlistAdd = WishlistAdd()
    
    // suggest category bool
    var checkboxCheck: Bool = false
    let validator = Validator()
    
    // search suggestions fill
    var subcategoryNames = [String]()
    var mainCategoryNames = [String]()
    // main + sub
    var allCategoryNames = [SearchTextFieldItem]()
    
    
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
        
        // TODO: create func for this -  toggle custom category mode
        self.showDefaultCategoryForm(bool: true)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prepopulate suggestions
        self.wishlistAdd.categorySearchTextField.showLoadingIndicator()
        self.getAllCscsid()
        self.wishlistAdd.categorySearchTextField.stopLoadingIndicator()
    }
    
    func showDefaultCategoryForm(bool: Bool) {
        self.wishlistAdd.mainCategory.isHidden = bool
        self.wishlistAdd.subCategoryCustom.isHidden = bool
        checkboxCheck = !bool
        self.wishlistAdd.categorySearchTextField.isHidden = !bool
        self.wishlistAdd.CategoryTagListView.isHidden = !bool
    }
    
    
    private func initUILayout() {
        self.wishlistAdd = self.loadFromNibNamed(nibNamed: Constants.xib.wishlistAddView) as! WishlistAdd
        self.view = self.wishlistAdd
        
        
        self.wishlistAdd.Description.delegate = self
        self.wishlistAdd.Name.delegate = self
        
        self.wishlistAdd.categorySearchTextField.addTarget(self, action: #selector(WishlistAddViewController.getSubCatWithHeadersSuggestions), for: UIControlEvents.allTouchEvents)
        
        self.wishlistAdd.categorySearchTextField.theme.font = UIFont.systemFont(ofSize: 14)
        
        self.wishlistAdd.mainCategory.addTarget(self, action: #selector(WishlistAddViewController.getMainCatOnlySuggestions), for: UIControlEvents.allTouchEvents)
        
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
        
        
        
        self.wishlistAdd.mainCategory.filterStrings(mainCategoryNames)
        
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
        
        
        self.wishlistAdd.categorySearchTextField.filterItems(allCategoryNames)
        
        self.wishlistAdd.categorySearchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            
            // subcat is clicked
            if (item.subtitle != nil && (item.subtitle?.characters.count)! > 0) {
                
                // TODO filter duplicates
                if (self.hasDuplicate(item: item.subtitle!)) {
                    self.toast(message: "Already exists")
                } else {
                    self.wishlistAdd.CategoryTagListView.addTag(item.subtitle!)
                    self.wishlistAdd.categorySearchTextField.text = ""
                    
                }
                
                
                // main cat is clicked -  void
            } else {
                // TODO: retain focus and suggestion list
            }
            
        }
        
        // Stop loading indicator
        self.wishlistAdd.categorySearchTextField.stopLoadingIndicator()
    }
    
    func hasDuplicate(item: String) -> Bool {
        for tagView in self.wishlistAdd.CategoryTagListView.tagViews {
            // TODO
            print("tagView", tagView.currentTitle)
            if (tagView.currentTitle?.lowercased() ==  item.lowercased()) {
                return true
            }
        }
        return false
    }
    
    
    
    fileprivate func getAllCscsid() {
        
        let categories =  CategoryService.getCategories()
        
        for category in categories {
            mainCategoryNames.append(category.name)
            
            self.allCategoryNames.append(SearchTextFieldItem(title: category.name, subtitle: nil, image: nil))
            
            
            let subcategories =  CategoryService.getSubcategoriesBy(categoryId: category.id)
            
            for subcategory in subcategories {
                let searchItem = SearchTextFieldItem(title: "", subtitle: category.name, image: nil)
                self.allCategoryNames.append(searchItem)
                
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
        tagView.isSelected = !tagView.isSelected
        self.wishlistAdd.CategoryTagListView.removeTagView(tagView)
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
    
    
    func performAction() {
        
        self.wishlistAdd.CategoryTagListView.addTag(self.wishlistAdd.categoryUITextField.text!)
        
        
    }
    
}


// MARK: - LoginViewDelegate
extension WishlistAddViewController: WishlistAddViewDelegate {
    func submitButtonOnPressed(sender: AnyObject){
        
        self.wishlistAdd.endEditing(true)
        self.validator.validate(self)
        
        
    }
    func checkBoxTicked(sender: AnyObject){
        
        
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
                    
                    selectedTags["main_category_id"] = categories.main_category_id as AnyObject
                    selectedTags["subcategory_id"] = categories.subcategory_id as AnyObject
                    
                }
                
                a.addObjects(from: [selectedTags as! Any])
                
            }
            
            print("SLECTED TAGS",a)
            SwiftSpinner.show("Please wait..")
            WishListService.createWishlist(category: a , name: name, description: desc) { statusCode, message in
                
                print("STATUS CODE",statusCode)
                if statusCode! == 201 {
                    
                    SwiftSpinner.hide()
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue:"pass"), object: nil, userInfo: nil)
                    self.navigationController?.popViewController(animated: true)
                    
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
        performAction()
        textField.resignFirstResponder()
        return true
    }
}

extension WishlistAddViewController: CheckboxDelegate {
    func didSelect(_ checkbox: CCheckbox) {
        switch checkbox {
        case self.wishlistAdd.checkboxUICCheckbox:
            self.showDefaultCategoryForm(bool: false)
            break
        default:
            break
        }
    }
    
    func didDeselect(_ checkbox: CCheckbox) {
        switch checkbox {
        case self.wishlistAdd.checkboxUICCheckbox:
            self.showDefaultCategoryForm(bool: true)
            break
        default:
            break
        }
    }
}


