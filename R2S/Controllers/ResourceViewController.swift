//
//  ResourceViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift

class ResourceViewController: BaseViewController {
    
    var resourceView = ResourceView()
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
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.resourceView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.resourceView.frame.width, height: self.resourceView.frame.height)
        self.view.addSubview(self.resourceView)
        self.resourceView.subcategoryCollectionView.register(UINib(nibName: Constants.xib.subcategoryCollectionCell, bundle: nil), forCellWithReuseIdentifier: "SubcategoryCollectionCell")
        self.resourceView.subcategoryCollectionView.delegate = self
        self.resourceView.subcategoryCollectionView.dataSource = self
       
        if let flowLayout = self.resourceView.subcategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        self.resourceView.subcategoryCollectionView.reloadData()
    }
    
    private func configureNavBar() {
        self.title = selectedCategoryName
        self.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ResourceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.resourceView.subcategoryCollectionView {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            CategoryService.clearSelectedSubcategories(self.subcategories)
            CategoryService.selectSubategory(self.subcategories[indexPath.item])
            self.resourceView.subcategoryCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ResourceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.resourceView.subcategoryCollectionView {
            return self.subcategories.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.resourceView.subcategoryCollectionView {
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
