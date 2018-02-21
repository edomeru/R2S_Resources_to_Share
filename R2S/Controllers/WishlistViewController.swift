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
import SwiftyJSON
import Kingfisher
import MIBadgeButton_Swift
import Floaty

class WishlistViewController: BaseViewController {
    var floaty = Floaty()
    var wishlistView = WishlistView()
    var wishList: Results<WishList>!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedWishListId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
     self.title = "Wishlist"
        
       NotificationCenter.default.addObserver(self, selector: #selector(WishlistViewController.reloadTableWishList(_:)), name: NSNotification.Name(rawValue: "pass"), object: nil)
       
    
    }
    
    
    func reloadTableWishList(_ notification: Notification)  {
        //print("DATA",notification.object)
//        wishList = notification.object as? Results<WishList>!
//        print("reloadTable", wishList)
//        //self.initUILayout()
//        self.wishlistView.WishListTableView.reloadData()
        
        fetchData()

        
    }
    
     func fetchData(){
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        WishListService.getAllWishList(onCompletion: { (statusCode, message) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                activityIndicator.stopAnimating()
            print("\(statusCode!)" + " WISH CODE"  )
            print("\(message!)" + " WISH MSG WISHLIST CONTROLLER FROM SERVICE"  )
            if statusCode == 200 {
                
                self.wishList = WishListDao.get()
            print("\(self.wishList)" + " WISH MSG WISHLIST CONTROLLER FROM DAO"  )
                self.initUILayout()
               
            }
                })
        })
    
    }
    
   
    
    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        self.wishlistView = self.loadFromNibNamed(nibNamed: Constants.xib.wishlistView) as! WishlistView
        self.view = self.wishlistView
        
        self.wishlistView.delegate = self
        print("INIT LAYOUT")
        self.wishlistView.WishListTableView.register(UINib(nibName: Constants.xib.wishListTableViewCell, bundle:nil), forCellReuseIdentifier: "WishListTableViewCell")
        self.wishlistView.WishListTableView.delegate = self
        self.wishlistView.WishListTableView.dataSource = self
        
       
        floaty.addItem(title: "Hello, World!")
        floaty.buttonColor = UIColor.blue
        floaty.plusColor = UIColor.white
        floaty.fabDelegate = self
        
        self.wishlistView.addSubview(floaty)
        self.wishlistView.WishListTableView.reloadData()
        
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
            case Constants.segue.wishToWishListDetailSegue:
                let destinationVC = segue.destination as! WishlistDetailViewController
                destinationVC.selectedWishListId = selectedWishListId
                
            default:
                print("default");
            }
        }
    }
    
    
}


// MARK: - UITableViewDelegate
extension WishlistViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
// MARK: - UITableViewDelegate
extension WishlistViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.wishlistView.WishListTableView {
            return self.wishList.count
           
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListTableViewCell", for: indexPath) as! WishListTableViewCell
        
        print("WISHLIST TABLEVIEW CELL")
        cell.name.text =  wishList[indexPath.row].name

        
        
        cell.descriptionUILabel.text = wishList[indexPath.row].descriptionText
//        cell.priceLabel.text = "$ \(resources[indexPath.row].price).00"
//        cell.infoLabel.text = resources[indexPath.row].descriptionText
//        
//        
//        for img in resources[indexPath.row].image {
//            
//            cell.productImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
//            cell.productImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
//            cell.productImageView.clipsToBounds = true
//            cell.productImageView.kf.setImage(with:  URL(string: img.image))
//            
//        }
//        
//        Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wish = wishList[indexPath.item]
        selectedWishListId  = wish.id
        // print (resource.id)
        performSegue(withIdentifier: Constants.segue.wishToWishListDetailSegue, sender: self)
    }
}

// MARK: - LoginViewDelegate
extension WishlistViewController: WishlistViewDelegate {
     func segmentedViewOnPressed(sender: AnyObject){
     
        print("SEGMENTED",sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            
//            if wishList.count != WishListDao.get().count {
//                
//                fetchData()
//                self.wishlistView.WishListTableView.reloadData()
//                
//            }else{
            let allWishlist = WishListDao.get()
                self.wishList = allWishlist
            print("\(self.wishList)" + " WISH MSG WISHLIST CONTROLLER FROM SEGMENTED 0"  )
                self.wishlistView.WishListTableView.reloadData()
            
            //}
            
        }else{
            
            self.wishList =  WishListDao.getAllWishByUser(id: UserHelper.getId()!)
            print("\(self.wishList)" + " WISH MSG WISHLIST CONTROLLER FROM SEGMENTED 1"  )
            self.wishlistView.WishListTableView.reloadData()
           
        }
        
    }
    

    
    
}


extension WishlistViewController: FloatyDelegate {

    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
        
        performSegue(withIdentifier: "WishToAddWishListSegue", sender: self)
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
        self.floaty.close()
        
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
    }



}
