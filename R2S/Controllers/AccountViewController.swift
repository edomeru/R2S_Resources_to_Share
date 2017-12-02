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

class AccountViewController: BaseViewController {

    var accountView = AccountView()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedCategoryId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountViewController")
     //   let dropDown = DropDown()
        self.initUILayout()
        
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
        
        

        // Do any additional setup after loading the view.
        
//        ResourceService.get(onCompletion: { statusCode, message in
//        
//        print("\(statusCode!)" + " TEST NI EDS"  )
//            print("\(message!)" + " TEST NI EDS"  )
//        
//        })
        
        
//        ResourceService.getFavorites(id: 1, onCompletion: { statusCode, message in
//            
//            print("\(statusCode!)" + " TEST NI EDS getByAccount"  )
//            print("\(message!)" + " TEST NI EDS"  )
//            
//        })
        
//        let newResource = User()
//        newResource.id = 8
//        newResource.accountId = "34242"
//        newResource.birthDate = "adadadad"
//        newResource.createdDate = "thttthh"
//        newResource.deletedDate = "thttthh"
//        newResource.email = "thttthh"
//        newResource.firstName = "thttthh"
//        
//        newResource.imageUrl = "thttthh"
//        newResource.isSubscribed = true
//        newResource.landlineNumber = "thttthh"
//        newResource.lastName = "alarte"
//        newResource.mobileNumber = "97917391739"
//        newResource.password = "ihiqduadbaud"
//        newResource.status = "aldjadadad"
//        newResource.updatedDate = "adadbadgadvaud"
        
//        var someObject:[String : AnyObject] = ["account_id" : UserHelper.getId()! as AnyObject]

        
//        ResourceService.addToFavorites(resource_id: 8 ,params: someObject  , onCompletion: { statusCode, message in
//            
//            print("\(statusCode!)" + " TEST NI EDS addToFavorites"  )
//            print("\(message!)" + " TEST NI EDS"  )
//            
//        })
    
        
         var category1:[String : AnyObject] =  ["subcategory_id": 22 as AnyObject    ,"main_category_id": 10 as AnyObject]
        
        var categories:Array = [Dictionary<String, AnyObject>]()
        categories.append(category1)
        
        
        var someObject:[String : AnyObject] = ["image_url" : "http://web.r2s.tirsolutions.com/static/uploads/1492509242048_2.png" as AnyObject, "name":"Special Force" as AnyObject, "price": 20 as AnyObject, "quantity":8 as AnyObject,"resource_rate":"DAY" as AnyObject,"categories": categories as AnyObject , "description": "Slightly used." as AnyObject,]
        
       

        ResourceService.createResource(id: 2 , params: someObject, onCompletion: { statusCode, message in
            
            print("\(statusCode!)" + " TEST NI EDS createResource"  )
            print("\(message!)" + " TEST NI EDS"  )
            
        })
        
         print("USERID",UserHelper.getId())
       let Me =  UserDao.getOneBy(id: UserHelper.getId()! )
        print("FNAME",Me?.firstName)
        self.accountView.userNameUILabel.text = (Me?.firstName)! + " " + (Me?.lastName)!
        self.accountView.companyUILabel.text = "Total Integrated Resources"
        self.accountView.emailUILabel.text = (Me?.email)!
        print("profpic",Me?.imageUrl)
        if Me?.imageUrl != "" {
        self.accountView.profilePicImageView.kf.setImage(with:  URL(string: (Me?.imageUrl)!))
                            }
        

        
    }

    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height

        self.accountView = self.loadFromNibNamed(nibNamed: Constants.xib.accountView) as! AccountView
        self.view = self.accountView
        
        self.accountView.profileTableView.register(UINib(nibName: Constants.xib.resourceTableCell, bundle:nil), forCellReuseIdentifier: "ProfileTableViewCell")
        self.accountView.profileTableView.delegate = self
        self.accountView.profileTableView.dataSource = self
        
        
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
            case Constants.segue.homeToResourceSegue:
                let destinationVC = segue.destination as! BrowseViewController
                destinationVC.selectedCategoryId = selectedCategoryId
                destinationVC.selectedCategoryName = CategoryDao.getOneBy(categoryId: selectedCategoryId)?.name
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
            return 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ResourceTableViewCell
        
        
        cell.titleLabel.text =  "Special Force"
        
        
        
        cell.dateLabel.text = "November 17, 2017"
        cell.priceLabel.text = "$ 20.00"
        cell.infoLabel.text = "Slightly Used"
        cell.productImageView.image = UIImage(named:"jong_suk")
        
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
