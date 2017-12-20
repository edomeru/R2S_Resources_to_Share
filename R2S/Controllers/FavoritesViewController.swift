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
import TTGSnackbar

class FavoritesViewController: BaseViewController {
    
    var favoritesView = FavoritesView()
    var selectedResourceId: Int!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var favorites: Results<Favorites>!
    var selectedCategoryId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          fetchData()
        self.title = "Favorites"
        
        
        
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
        ResourceService.getFavorites(id: UserHelper.getId()! , onCompletion: { statusCode, message in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                activityIndicator.stopAnimating()
                
            let favorites = FavoritesDao.get()
            
            self.favorites = favorites
            self.initUILayout()
                
                })
            
        })
    
    }
    
    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        self.favoritesView = self.loadFromNibNamed(nibNamed: Constants.xib.favoritesView) as! FavoritesView
        self.view = self.favoritesView
        if  self.favorites != nil {
        self.favoritesView.FavoritesTableView.register(UINib(nibName: Constants.xib.favoritesTableCell, bundle:nil), forCellReuseIdentifier: "FavoritesTableViewCell")
        self.favoritesView.FavoritesTableView.delegate = self
        self.favoritesView.FavoritesTableView.dataSource = self
        } else {
            
        self.favoritesView.noFavoritesUILabel.isHidden = false
            
        }
        
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
            case "FavoritesToDetailSegue":
                let destinationVC = segue.destination as! ResourceViewController
                destinationVC.selectedResourceId = selectedCategoryId
                
            default:
                print("default");
            }
        }
    }
    
    func myFunction(gesture: UITapGestureRecognizer) {
        if let v = gesture.view {
        print("it worked",v.tag)
             let param:[String : AnyObject] = ["resource_id" : v.tag as AnyObject]
            ResourceService.removeFavoriteObject(params:param){ (statusCode, message) in
                //print("FAV STAT CODE",statusCode)
                if let statCode = statusCode {
                if statCode == 202 {
            
          let favObject = FavoritesDao.getOneBy(id: v.tag)
            FavoritesDao.delete(favObject!)
                    self.favoritesView.FavoritesTableView.reloadData()
                    
                    let snackbar = TTGSnackbar(message: "Item" + " has been removed ", duration: .short)
                    snackbar.backgroundColor = UIColor.blue
                    snackbar.show()
                    
                    
                    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
                    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
                    activityIndicator.activityIndicatorViewStyle = .gray
                    activityIndicator.center = self.view.center
                    activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
                    activityIndicator.center = self.view.center
                    activityIndicator.hidesWhenStopped = true
                    self.view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    ResourceService.getFavorites(id: UserHelper.getId()! , onCompletion: { statusCode, message in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            activityIndicator.stopAnimating()
                            
                            let favorites = FavoritesDao.get()
                            
                         
                            
                        })
                        
                    })
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
              }
           }
        }
        
    }

   
}



// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
}
// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.favorites.count != 0 {
            //table view is empty here
        
        if tableView == self.favoritesView.FavoritesTableView {
            
            return self.favorites.count
          }
        } else {
        self.favoritesView.FavoritesTableView.isHidden = true
        self.favoritesView.noFavoritesUILabel.isHidden = false
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        
        cell.favTitleUILabel.text =  favorites[indexPath.row].name
        
        
        
        cell.favDateUILabel.text = favorites[indexPath.row].createdDate
        cell.priceUILabel.text = "$ \(favorites[indexPath.row].price).00"
        cell.descriptionTextUILabel.text = favorites[indexPath.row].descriptionText
        
        
        for img in favorites[indexPath.row].image {
            
            cell.favImage.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            cell.favImage.contentMode = .scaleAspectFit // OR .scaleAspectFill
            cell.favImage.clipsToBounds = true
            cell.favImage.kf.setImage(with:  URL(string: img.image))
            
        }
        
        
        
        cell.favoriteIconUIImageView.isUserInteractionEnabled = true
        cell.favoriteIconUIImageView.tag = favorites[indexPath.row].id
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(FavoritesViewController.myFunction))
        tapped.numberOfTapsRequired = 1
        cell.favoriteIconUIImageView.addGestureRecognizer(tapped)
        
        
    //cell.favoriteIconUIImageView.gestureRecognizers
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FavoritesTableViewCell
       
    
        
        
        
        
        
                let favorite = favorites[indexPath.item]
        selectedCategoryId  = favorite.id
        // print ("favorite.id",favorite.id)
        performSegue(withIdentifier: "FavoritesToDetailSegue", sender: self)
        
        
    
       }
    
     
    
    
    }


