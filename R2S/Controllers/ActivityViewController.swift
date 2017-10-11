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

class ActivityViewController: BaseViewController {

    var activityView = ActivityView()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var categories: Results<Category>!
    var selectedCategoryId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUILayout()
        // Do any additional setup after loading the view.
        
        TransactionService.fetchTransactions { (statusCode, message) in
            print(statusCode)
        }
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

        self.activityView = self.loadFromNibNamed(nibNamed: Constants.xib.activityView) as! ActivityView
        self.view = self.activityView
        
        setupSegmentedControl()
    }
    private func setupSegmentedControl(){
        self.activityView.activitySegmentedControl.removeAllSegments()
        self.activityView.activitySegmentedControl.insertSegment(withTitle: "Buying", at: 0, animated: false)
        self.activityView.activitySegmentedControl.insertSegment(withTitle: "Selling", at: 1, animated: false)
        self.activityView.activitySegmentedControl.insertSegment(withTitle: "History", at: 2, animated: false)
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
extension ActivityViewController: UITableViewDelegate{
    
}

// MARK: - UITableViewDataSource
extension ActivityViewController: UITableViewDataSource{
    
}
