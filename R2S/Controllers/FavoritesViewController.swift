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
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedCategoryId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUILayout()
    
        self.title = "Favorites"
                ResourceService.getFavorites(id: UserHelper.getId()! , onCompletion: { statusCode, message in
        
                    print("\(statusCode!)" + " FAVORITES CODE"  )
                    print("\(message!)" + " FAVORITES MSG"  )
        
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
extension FavoritesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
}
// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.favoritesView.FavoritesTableView {
            //return self.resources.count
            
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        
//        cell.titleLabel.text =  resources[indexPath.row].name
//        
//        
//        
//        cell.dateLabel.text = resources[indexPath.row].createdDate
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
//        let resource = resources[indexPath.item]
//        selectedResourceId  = resource.id
//        // print (resource.id)
//        performSegue(withIdentifier: Constants.segue.browseToResourceSegue, sender: self)
    }
}

