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

class AccountViewController: BaseViewController {

    var accountView = AccountView()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedCategoryId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUILayout()
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height

        self.accountView = self.loadFromNibNamed(nibNamed: Constants.xib.accountView) as! AccountView
        self.view = self.accountView
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
