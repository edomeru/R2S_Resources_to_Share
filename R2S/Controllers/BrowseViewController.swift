//
//  ResourceViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift

class BrowseViewController: BaseViewController {
    
    var browseView = BrowseView()
    var selectedCategoryId: Int!
    var selectedCategoryName: String!
    var subcategories: Results<Subcategory>!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        self.configureNavBar()
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
    
    private func configureNavBar() {
        self.title = selectedCategoryName
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BrowseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.browseView.subcategoryCollectionView {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            CategoryService.clearSelectedSubcategories(self.subcategories)
            CategoryService.selectSubategory(self.subcategories[indexPath.item])
            self.browseView.subcategoryCollectionView.reloadData()
        }
    }
}


// MARK: - UITableViewDelegate
extension BrowseViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
// MARK: - UITableViewDelegate
extension BrowseViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.browseView.resourceTableView {
            
        }
        return 500
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
        return cell
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
