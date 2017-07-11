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

class HomeViewController: BaseViewController {

    var homeView = HomeView()
    var featuredPageControl = UIPageControl()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedCategoryId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshData()
        self.configureNavBar()
        
        // Do any additional setup after loading the view.
        
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

        self.homeView = self.loadFromNibNamed(nibNamed: Constants.xib.homeView) as! HomeView
        self.homeView.frame = CGRect(x: 0.0, y: Constants.navbarHeight, width: self.homeView.frame.width, height: self.homeView.frame.height)
        self.view.addSubview(self.homeView)
        
        self.homeView.homeTableView.register(UINib(nibName: Constants.xib.featuredTableCell, bundle: nil), forCellReuseIdentifier: "FeaturedTableCell")
        self.homeView.homeTableView.register(UINib(nibName: Constants.xib.categoryTableCell, bundle: nil), forCellReuseIdentifier: "CategoryTableCell")
        self.homeView.homeTableView.delegate = self
        self.homeView.homeTableView.dataSource = self
    }
    
    private func configureNavBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let cartButton = MIBadgeButton()
        let cartImage = UIImage(named: "ic_exit_to_app")
        cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cartButton.setImage(cartImage, for: .normal)
        cartButton.badgeEdgeInsets = UIEdgeInsetsMake(15, 0, 0, 0)
        cartButton.addTarget(self, action: #selector(self.cartButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: cartButton)
        self.tabBarController!.navigationItem.rightBarButtonItem = barButton
    }
    
    func cartButtonPressed() {
        _ = self.navigationController?.popToRootViewController(animated: true)
        CategoryDao.deleteAll()
        SubcategoryDao.deleteAll()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isLoggedIn")
    }
    
    private func refreshData() {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        CategoryService.fetchCategories { (statusCode, message) in
            if statusCode == 200 {
                self.categories = CategoryService.getCategories()
                CategoryService.clearSelectedCategories(self.categories)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    self.initUILayout()
                    self.homeView.homeTableView.reloadData()
                })
            } else {
                self.categories = CategoryService.getCategories()
                CategoryService.clearSelectedCategories(self.categories)
                self.initUILayout()
                Utility.showAlert(title: "Error", message: message!, targetController: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segue.homeToResourceSegue:
                let destinationVC = segue.destination as! ResourceViewController
                destinationVC.selectedCategoryId = selectedCategoryId
                destinationVC.selectedCategoryName = CategoryDao.getOneBy(categoryId: selectedCategoryId)?.name
            default:
                print("default");
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 180.0
        case 1:
            let categoryCount = ceil(Double(self.categories.count / 2))
            let itemHeight = (screenWidth / 2)
            let heightForRow = CGFloat(categoryCount) * itemHeight
            return heightForRow
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.homeView.homeTableView {
            switch indexPath.row {
            case 0:
                let computedHeight = CGFloat(180.0)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableCell", for: indexPath as IndexPath) as! FeaturedTableViewCell
                cell.preservesSuperviewLayoutMargins = false
                cell.separatorInset = UIEdgeInsets.zero
                cell.layoutMargins = UIEdgeInsets.zero
                let scrollViewWidth = cell.featuredCarouselScrollView.frame.width
                let scrollViewHeight = cell.featuredCarouselScrollView.frame.height
                cell.featuredCarouselScrollView.frame = CGRect(x: 0, y: 0, width: cell.featuredCarouselScrollView.frame.width, height: computedHeight + 6)
                cell.featuredCarouselScrollView.contentSize = CGSize(width: scrollViewWidth * 3, height: 1)
                
                let featuredCarouselView1 = loadFromNibNamed(nibNamed: Constants.xib.featuredCarouselItem) as! FeaturedCarouselItemView
                let featuredCarouselView2 = loadFromNibNamed(nibNamed: Constants.xib.featuredCarouselItem) as! FeaturedCarouselItemView
                let featuredCarouselView3 = loadFromNibNamed(nibNamed: Constants.xib.featuredCarouselItem) as! FeaturedCarouselItemView
                
                featuredCarouselView1.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
                featuredCarouselView2.frame = CGRect(x: scrollViewWidth * CGFloat(1), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                featuredCarouselView3.frame = CGRect(x: scrollViewWidth * CGFloat(2), y: 0, width: scrollViewWidth, height: scrollViewHeight)
                
                cell.featuredCarouselScrollView.addSubview(featuredCarouselView1)
                cell.featuredCarouselScrollView.addSubview(featuredCarouselView2)
                cell.featuredCarouselScrollView.addSubview(featuredCarouselView3)
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath as IndexPath) as! CategoryTableViewCell
                cell.categoryCollectionViewCell.register(UINib(nibName: Constants.xib.categoryCollectionCell, bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionCell")
                cell.categoryCollectionViewCell.delegate =  self
                cell.categoryCollectionViewCell.dataSource = self
                
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                layout.itemSize = CGSize(width: (screenWidth / 2) - 11, height: ((screenWidth / 2) - 11) - 11)
                layout.minimumInteritemSpacing = 6
                layout.minimumLineSpacing = 6
                cell.categoryCollectionViewCell.collectionViewLayout = layout
                cell.categoryCollectionViewCell.isScrollEnabled = false
                cell.categoryCollectionViewCell.reloadData()
                return cell
            default:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryId = self.categories[indexPath.item].id
        self.performSegue(withIdentifier: Constants.segue.homeToResourceSegue, sender: self)
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = self.categories[indexPath.item].name
        
//        print (self.categories[indexPath.item])
        
        let imageUrl = self.categories[indexPath.item].imageUrl
        cell.categoryImageView.kf.indicatorType = .activity
        
        if (imageUrl == ""){
            let url = URL(string: "http://theblackpanthers.com/s/photogallery/img/no-image-available.jpg")
            cell.categoryImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
            cell.categoryImageView.bounds = view.frame.insetBy(dx: 10.0, dy: 10.0);
        }
        else{
            let url = URL(string: imageUrl)
            cell.categoryImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
            cell.categoryImageView.bounds = view.frame.insetBy(dx: 10.0, dy: 10.0);
        }
        
        
        
        return cell
    }
}
