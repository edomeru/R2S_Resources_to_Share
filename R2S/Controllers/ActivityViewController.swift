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
import SwiftyJSON


class ActivityViewController: BaseViewController {

    var activityView = ActivityView()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var transactions: Results<Transaction>!
    var selectedCategoryId: Int!
    var resources: Results<Transaction>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromSource()
        
        
        
      
    }

    func fetchDataFromSource(){
        SwiftSpinner.show("Please wait..")
        TransactionService.fetchTransactions { (statusCode, message) in
            SwiftSpinner.hide()
            print(statusCode)
          
            if statusCode == 200 {
            
                let transaction = TransactionDao.getTransactions()
                print("TRANSACTIONDAO", transaction.count)
                self.transactions = transaction
                self.initUILayout()
                self.activityView.activityTableView.reloadData()
            }

        }
      
        
    }

    // MARK: - Private Functions
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height

        self.activityView = self.loadFromNibNamed(nibNamed: Constants.xib.activityView) as! ActivityView
        self.view = self.activityView
        
        self.activityView.activityTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        self.activityView.activityTableView.delegate = self
        self.activityView.activityTableView.dataSource = self
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

// MARK: - UITableViewDataSource
extension ActivityViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath as IndexPath) as! TransactionTableViewCell
        cell.orderRefNumberUILabel.text = transactions[indexPath.item].referenceCode
        cell.startDateUILabel.text = transactions[indexPath.item].bookingStartDate
        cell.endDateUILabel.text = transactions[indexPath.item].bookingEndDate
        cell.resourceNameUILabel.text = transactions[indexPath.item].resource?.name
        cell.resourceDescriptionUILabel.text = transactions[indexPath.item].resource?.descriptionText
        cell.endDateUILabel.text = transactions[indexPath.item].bookingEndDate
       
      if  self.transactions[indexPath.item].resource?.imageUrl != "" {
     
        cell.resourceUIImageView.kf.setImage(with: URL(string: (transactions[indexPath.item].resource?.imageUrl)!), options: [.transition(.fade(0.2))])
        
        }else{
        
        
         let url = URL(string: "http://theblackpanthers.com/s/photogallery/img/no-image-available.jpg")
        cell.resourceUIImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
        }
        
        
        
        
        return cell
    }
}
