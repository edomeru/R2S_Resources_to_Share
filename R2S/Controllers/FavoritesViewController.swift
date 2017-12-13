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
        ResourceService.getFavorites(id: UserHelper.getId()! , onCompletion: { statusCode, message in
            let favorites = FavoritesDao.get()
            
            print("FAV CONTROLLER", favorites )
            self.favorites = favorites
            self.initUILayout()
            
        })
    
    }
    
    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        
        
        self.favoritesView = self.loadFromNibNamed(nibNamed: Constants.xib.favoritesView) as! FavoritesView
        self.view = self.favoritesView
        
        self.favoritesView.FavoritesTableView.register(UINib(nibName: Constants.xib.favoritesTableCell, bundle:nil), forCellReuseIdentifier: "FavoritesTableViewCell")
        self.favoritesView.FavoritesTableView.delegate = self
        self.favoritesView.FavoritesTableView.dataSource = self
        
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
        print("it worked",gesture)
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
        if tableView == self.favoritesView.FavoritesTableView {
            
            return self.favorites.count
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
        
        
        
//        cell.favoriteIconUIImageView.isUserInteractionEnabled = true
//        cell.favoriteIconUIImageView.tag = indexPath.row
//        
//        let tapped = UITapGestureRecognizer(target: self, action: #selector(FavoritesViewController.myFunction))
//        tapped.numberOfTapsRequired = 1
//        cell.favoriteIconUIImageView.addGestureRecognizer(tapped)
        
        
        //cell.favoriteIconUIImageView.gestureRecognizers
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FavoritesTableViewCell
       
    
        
         cell.favoriteIconUIImageView.image = UIImage(named: "icons8-heart-blank")
        
//        let favorite = favorites[indexPath.item]
//        selectedCategoryId  = favorite.id
//         print ("favorite.id",favorite.id)
//        performSegue(withIdentifier: "FavoritesToDetailSegue", sender: self)
        
        
    
       }
    
     
    
    
    }


