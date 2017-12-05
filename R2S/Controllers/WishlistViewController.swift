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

class WishlistViewController: BaseViewController {
    
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
        
    
    }
    
    private func fetchData(){
        WishListService.getAllWishList(onCompletion: { statusCode, message in
            
            print("\(statusCode!)" + " WISH CODE"  )
            print("\(message!)" + " WISH MSG"  )
            if statusCode == 200 {
                self.wishList = WishListDao.get()
                self.initUILayout()
            }
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
        
        self.wishlistView.WishListTableView.register(UINib(nibName: Constants.xib.wishListTableViewCell, bundle:nil), forCellReuseIdentifier: "WishListTableViewCell")
        self.wishlistView.WishListTableView.delegate = self
        self.wishlistView.WishListTableView.dataSource = self
        
        
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
        return 80
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
            
            self.wishList = WishListDao.get()
            self.wishlistView.WishListTableView.reloadData()
            
        }else{
            
            self.wishList =  WishListDao.getAllWishByUser(id: UserHelper.getId()!)
            self.wishlistView.WishListTableView.reloadData()
           
        }
        
    }
    
    
}
