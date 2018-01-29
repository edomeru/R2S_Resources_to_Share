//
//  HomeViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftSpinner
import Kingfisher
import MIBadgeButton_Swift
import DropDown
import Auk
import moa
import Foundation
import CZPicker

class AccountViewController: BaseViewController {

    var accountView = AccountView()
    var myResource : Results<Resource>!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedCategoryId: Int!
    var settings = [String]()
    var setingsSelected: String?
    var Me: User?
    var reloadView:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountViewController")
        reloadView = false
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.reloadProfile(_:)), name: NSNotification.Name(rawValue: "pass"), object: nil)
        
        initUILayout()
        
     //   let dropDown = DropDown()
        
        
      //  let chooseArticleDropDown = DropDown()
        
//        var dropDowns: [DropDown] = {
//            return [
//                self.chooseArticleDropDown,
//                self.amountDropDown,
//                self.chooseDropDown,
//                self.centeredDropDown,
//                self.rightBarDropDown
//            ]
//        }()
//        
//        chooseArticleDropDown.anchorView = self.accountView.settingsUIButton
//        
//        chooseArticleDropDown.dataSource = [
//            "iPhone SE | Black | 64G",
//            "Samsung S7",
//            "Huawei P8 Lite Smartphone 4G",
//            "Asus Zenfone Max 4G",
//            "Apple Watwh | Sport Edition"
//        ]
//        
//        // Action triggered on selection
//        chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
//            self.self.accountView.settingsUIButton.setTitle(item, for: .normal)
//        }
        
        
     
    
        
//         var category1:[String : AnyObject] =  ["subcategory_id": 22 as AnyObject    ,"main_category_id": 10 as AnyObject]
//        var category2:[String : AnyObject] =  ["subcategory_id": 22 as AnyObject    ,"main_category_id": 2 as AnyObject]
//        print("PRINT_category1", category1)
//        var categories:Array = [Dictionary<String, AnyObject>]()
//        categories.append(category1)
//        categories.append(category2)
//        print("PRINT_categoriesARRAY", categories)
//        
//        var someObject:[String : AnyObject] = ["image_url" : "http://web.r2s.tirsolutions.com/static/uploads/1492509242048_2.png" as AnyObject, "name":"Special Force" as AnyObject, "price": 20 as AnyObject, "quantity":8 as AnyObject,"resource_rate":"DAY" as AnyObject,"categories": categories as AnyObject , "description": "Slightly used." as AnyObject,]
//        
//       print("PRINT_PARAM", someObject)

//        ResourceService.createResource(id: 2 , params: someObject, onCompletion: { statusCode, message in
//            
//            print("\(statusCode!)" + " TEST NI EDS createResource"  )
//            print("\(message!)" + " TEST NI EDS"  )
//            
//        })
        
       
        
    }
    
    func loadResource(){
    
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.startAnimating()
        ResourceService.get{ (statusCode, message) in
            if statusCode == 200 {
                
                self.myResource =  ResourceDao.getByAccountId(accountId: UserHelper.getId()!)
             
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    
                    
                    
                    
                    
                    self.accountView.profileTableView.register(UINib(nibName: Constants.xib.ProfileTableViewCell, bundle:nil), forCellReuseIdentifier: "ProfileTableViewCell")
                    
                    
                    self.accountView.profileTableView.delegate = self
                    self.accountView.profileTableView.dataSource = self
                    self.accountView.profileTableView.reloadData()
                    print("RELOAD", self.reloadView!)
                    if self.reloadView! == false {
                    self.accountView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
                    self.view = self.accountView
                    } else {
                        self.accountView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        self.view = self.accountView
                    }
                
                    
                })
            } else {
                
                Utility.showAlert(title: "Error", message: message!, targetController: self)
            }
        }

    
    
    
    
    }
    
    func reloadProfile(_ notification: Notification) {
        print("reloadProfile")
        //Me = notification.object  as?  User
        reloadView = true
        self.initUILayout()
        
    }
   

    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height

        self.accountView = self.loadFromNibNamed(nibNamed: Constants.xib.accountView) as! AccountView
        self.accountView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view = self.accountView
        self.accountView.delegate = self
       
        
         Me =  UserDao.getOneBy(id: UserHelper.getId()! )
        print("UserDao.getOneBy",Me)
        if let user = Me {
            
            self.accountView.userNameUILabel.text = (user.firstName) + " " + (user.lastName)
            
            
            self.accountView.emailUILabel.text = (user.email)
            self.accountView.phoneUILabel.text = (user.landlineNumber)
            self.accountView.companyUILabel.text = user.company?.name
           
            if user.imageUrl != "" {
                self.accountView.profilePicImageView.kf.indicatorType = .activity
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                self.accountView.profilePicImageView.kf.setImage(with:  URL(string: user.imageUrl), placeholder: nil, options: [.processor(processor)])
            }
            
        
            
            print("USERDAODFEF",Utility.stringToDate(dateString: user.createdDate))
            self.accountView.dateJoinedUILabel.text = "Joined " + (user.createdDate)
            
            
        }
        
       settings = ["Edit Profile", "Change Password", "App Settings", "Raise Support Ticket"]
         loadResource()
        
    }
    
    
    
    func settingsTapped() {
        let pickerDialog = CZPickerView(headerTitle: "Settings", cancelButtonTitle: "Cancel", confirmButtonTitle: "Ok")
        pickerDialog?.delegate = self
        pickerDialog?.dataSource = self
        pickerDialog?.needFooterView = true
        pickerDialog?.headerBackgroundColor = UIColor(hexString: Constants.color.primary)
        pickerDialog?.tag = 1000
        pickerDialog?.confirmButtonBackgroundColor = UIColor(hexString: Constants.color.primary)
        pickerDialog?.checkmarkColor = .blue
        pickerDialog?.show()
    
    }
    
    private func refreshData() {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.color = UIColor(hex: Constants.color.primaryDark)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
//        CategoryService.fetchCategories { (statusCode, message) in
//            if statusCode == 200 {
//                activityIndicator.stopAnimating()
//                self.categories = CategoryService.getCategories()
//                CategoryService.clearSelectedCategories(self.categories)
//                self.initUILayout()
//                self.homeView.homeTableView.reloadData()
//            } else {
//                self.categories = CategoryService.getCategories()
//                CategoryService.clearSelectedCategories(self.categories)
//                self.initUILayout()
//                Utility.showAlert(title: "Error", message: message!, targetController: self)
//            }
//        }
//        activityIndicator.stopAnimating()
//        self.categories = CategoryService.getCategories()
//        CategoryService.clearSelectedCategories(self.categories)
//        self.initUILayout()
//        self.homeView.homeTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                
            case Constants.segue.profileToWelcomeSegue:
                let destinationVC = segue.destination as! WelcomeViewController
            case Constants.segue.profileToChangePasswordSegue:
                let destinationVC = segue.destination as! ChangePasswordViewController
              
            default:
                print("default");
            }
        }
    }
    
   
}

// MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
}


// MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.accountView.profileTableView {
            return self.myResource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        let myResources = myResource[indexPath.row]
        cell.titleLabel.text =  myResources.name
        
        
        
        cell.dateLabel.text = myResources.createdDate
        cell.priceLabel.text = "$" + myResources.price
        cell.infoLabel.text = myResources.descriptionText
        
       
        
        cell.productImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        cell.productImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
        cell.productImageView.clipsToBounds = true
        cell.productImageView.kf.indicatorType = .activity
        cell.productImageView.kf.setImage(with:  URL(string: myResources.imageUrl))
       
//        for img in resources[indexPath.row].image {
//            
//            cell.productImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
//            cell.productImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
//            cell.productImageView.clipsToBounds = true
//            cell.productImageView.kf.setImage(with:  URL(string: img.image))
//            
//        }
        
        //Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy
        return cell
 }
}


// MARK: - LoginViewDelegate
extension AccountViewController: AccountViewDelegate {
    func signoutButtonPressed(sender: AnyObject) {
       
        
        let dialogMessage = UIAlertController(title: "Confirm" , message: "are you sure you want to sign out?" , preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            UserDao.clear()
         
            print("RESOURCEDAO",ResourceDao.get())
            print("TRANSACTIONDAO",TransactionDao.getTransactions())
            
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            
            UserManager.sharedInstance.isLoggedIn = false
            
            self.performSegue(withIdentifier: Constants.segue.profileToWelcomeSegue, sender: self)
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    func settingsButtonPressed(sender: AnyObject) {
    
    settingsTapped()
    
    }

}

extension AccountViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    
    public func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
     
            print("picker 1 count", pickerView.tag)
            return settings.count
        
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        
        
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        
        
      
            print("picker 1 count", pickerView.tag)
            return settings.count
       
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        
       
            print("picker 1 count", pickerView.tag)
            return settings[row]
     
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        
        
        
        
        
        
        
            print("FRUITS didConfirmWithItemAtRow", settings[row])
            
            setingsSelected = settings[row]
            print(settings[row])
            
        setingsSelected = settings[row]
        
        
        
        
        if setingsSelected == "Edit Profile" {
            
            self.performSegue(withIdentifier: Constants.segue.profileToEditProfileSegue, sender: self)
            
        }else if setingsSelected == "Change Password" {
            print("performSegueChangePassword")
             self.performSegue(withIdentifier: Constants.segue.profileToChangePasswordSegue, sender: self)
            
            
        }else if setingsSelected == "App Settings" {
            
             self.performSegue(withIdentifier: Constants.segue.profileToAppSettingsSegue, sender: self)
            
        }else if setingsSelected == "Raise Support Ticket" {
            
             self.performSegue(withIdentifier: Constants.segue.profileToRaiseSupportTicketSegue, sender: self)
            
            
        }
        
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
}

}
