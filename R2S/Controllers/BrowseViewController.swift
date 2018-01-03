//
//  ResourceViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift
import Auk
import moa
import TTGSnackbar

class BrowseViewController: BaseViewController {
    
    var favoriteOrNot: Bool!
    var browseView = BrowseView()
    var selectedCategoryId: Int!
    var selectedCategoryName: String!
    var resources: Results<Resource>!
    var subcategories: Results<Subcategory>!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var selectedResourceId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavBar()
        fetchDataFromSource()
        
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
        
        self.subcategories = CategoryService.getSubcategoriesBy(categoryId: self.selectedCategoryId)
        CategoryService.clearSelectedSubcategories(self.subcategories)
        CategoryService.selectSubategory(self.subcategories[0])
        
        self.browseView = self.loadFromNibNamed(nibNamed: Constants.xib.browseView) as! BrowseView
        self.browseView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.browseView)
        
        self.browseView.subcategoryCollectionView.register(UINib(nibName: Constants.xib.subcategoryCollectionCell, bundle: nil), forCellWithReuseIdentifier: "SubcategoryCollectionCell")
        self.browseView.subcategoryCollectionView.delegate = self
        self.browseView.subcategoryCollectionView.dataSource = self
        
        self.browseView.resourceTableView.register(UINib(nibName: Constants.xib.resourceTableCell, bundle:nil), forCellReuseIdentifier: "ResourceTableViewCell")
        self.browseView.resourceTableView.delegate = self
        self.browseView.resourceTableView.dataSource = self
        
        if let flowLayout = self.browseView.subcategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        self.browseView.subcategoryCollectionView.reloadData()
    }
    func myFunction(gesture: UITapGestureRecognizer) {
        if let v = gesture.view {
            print("it worked",v.tag)
            let resource = ResourceDao.getOneBy(id: v.tag)
            
            print("RESOURCE_ID",resource?.id)
            
            let param:[String : AnyObject] = ["account_id" : UserHelper.getId() as AnyObject]
            ResourceService.addToFavorites(resource_id: (resource?.id)!, params:param){ (statusCode, message) in
                //print("FAV STAT CODE",statusCode)
                print("STATUSCODE",statusCode)
                print("MSG",message)
                if let statCode = statusCode {
                    if statCode == 202 {
                        print("PRINT_THISFAV", self.favoriteOrNot!)
                        
                       
                        
                         if message! != "Successfully updated" {
                            
                      print("DELTE_FAV")
                            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
                            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
                            activityIndicator.activityIndicatorViewStyle = .gray
                            activityIndicator.center = self.view.center
                            activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
                            activityIndicator.center = self.view.center
                            activityIndicator.hidesWhenStopped = true
                            self.view.addSubview(activityIndicator)
                            activityIndicator.startAnimating()
                        let favorite = FavoritesDao.getOneBy(id: (resource?.id)!)
                            print("favorite DEL" ,favorite?.id)
                        FavoritesDao.delete(favorite!)
                          let fb =  FavoritesDao.get()
                            print("PRINT_AFTER_ADDING_RESOURCE",fb)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                activityIndicator.stopAnimating()
                            
                        self.browseView.resourceTableView.reloadData()
                        
                        let snackbar = TTGSnackbar(message: "Removed from favorites ", duration: .short)
                        snackbar.backgroundColor = UIColor.blue
                        snackbar.show()
                        self.favoriteOrNot!  = false
                                
                            })
                            
                         }  else  {
                        print("ADD_FAV")
                            
                            
                           
                            
                             
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                                    activityIndicator.stopAnimating()
                                    
                                    let favorites = FavoritesDao.get()
                                    print("PRINT_AFTER_ADDING_RESOURCE",favorites)
                                    // print("FAV CONTROLLER", favorites )
                                    self.browseView.resourceTableView.reloadData()
                                    let snackbar = TTGSnackbar(message: "Item" + " has been added to Favorites ", duration: .short)
                                    snackbar.backgroundColor = UIColor.green
                                    snackbar.show()
                                    
                                    self.favoriteOrNot!  = true
                                    
                                    
                                })
                                
                            })
                            
                            
                            
                        

                        }
                        
                        
                        
                    }
                }
            }
            
            
            
            
            
            
            
            
            
            
        }
    }
    
    func fetchDataFromSource(){
        
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
                self.resources = ResourceDao.get();
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    self.initUILayout()
                    self.browseView.resourceTableView.reloadData()
                })
            } else {
                self.resources = ResourceDao.get();
                Utility.showAlert(title: "Error", message: message!, targetController: self)
            }
        }
        
    }
    
    private func configureNavBar() {
        self.title = selectedCategoryName
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ResourceViewController
        destinationVC.selectedResourceId = selectedResourceId
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BrowseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.browseView.subcategoryCollectionView {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            CategoryService.clearSelectedSubcategories(self.subcategories)
            //print(self.subcategories[indexPath.item].id)
            //print("PRINT1",subcategories.count)
            let resourcesByCategorySelected = ResourceService.getBySubCategory(id: self.subcategories[indexPath.item].id)
            
            //print("PRINT",resourcesByCategorySelected?.count)
            
            resources = resourcesByCategorySelected
            
            CategoryService.selectSubategory(self.subcategories[indexPath.item])
            self.browseView.subcategoryCollectionView.reloadData()
            self.browseView.resourceTableView.reloadData()
            
        }
    }
}


// MARK: - UITableViewDelegate
extension BrowseViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
}
// MARK: - UITableViewDelegate
extension BrowseViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.browseView.resourceTableView {
            return self.resources.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        
        
        cell.titleLabel.text =  resources[indexPath.row].name
        
        
        
        cell.dateLabel.text = resources[indexPath.row].createdDate
        cell.priceLabel.text = "$ \(resources[indexPath.row].price).00"
        cell.infoLabel.text = resources[indexPath.row].descriptionText
        
        
        for img in resources[indexPath.row].image {
            
            cell.productImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
            cell.productImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
            cell.productImageView.clipsToBounds = true
            cell.productImageView.kf.setImage(with:  URL(string: img.image))
            
        }
        
       
         favoriteOrNot = FavoritesDao.isFavorite(id: resources[indexPath.row].id)
        print("favoriteOrNot",favoriteOrNot)
        
        if favoriteOrNot! {
            cell.favoriteUIImageView.image = UIImage(named:"icons8-heart-pink")
            print("NAME %s %@",resources[indexPath.row].name, favoriteOrNot)
            
        }else {
            cell.favoriteUIImageView.image = UIImage(named:"icons8-heart-blank")
            print("NAME %s %@",resources[indexPath.row].name, favoriteOrNot)
            
        }
        
        cell.favoriteUIImageView.isUserInteractionEnabled = true
        cell.favoriteUIImageView.tag = resources[indexPath.row].id
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(FavoritesViewController.myFunction))
        tapped.numberOfTapsRequired = 1
        cell.favoriteUIImageView.addGestureRecognizer(tapped)
        
        Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resource = resources[indexPath.item]
        if let cell = tableView.cellForRow(at: indexPath) {
            
//         let favIcon = cell.viewWithTag(1000) as! UIImageView
//            if  favoriteOrNot {
//           
// 
//            }
            
        selectedResourceId  = resource.id
        // print (resource.id)
        performSegue(withIdentifier: Constants.segue.browseToResourceSegue, sender: self)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BrowseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.browseView.subcategoryCollectionView {
            return self.subcategories.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.browseView.subcategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcategoryCollectionCell", for: indexPath) as! SubCategoryCollectionViewCell
            cell.subcategoryLabel.text = self.subcategories[indexPath.item].name
            
            if self.subcategories[indexPath.item].isSelected {
                cell.categoryUnderlineView.backgroundColor = UIColor(hex: Constants.color.primary)
            } else {
                cell.categoryUnderlineView.backgroundColor = UIColor.clear
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
