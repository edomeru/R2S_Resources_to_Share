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
    var selectedSegment: Int?
    var screenHeight: CGFloat!
    var transactions: Results<Transaction>!
    var selectedCategoryId: Int!
    var resources: Results<Transaction>!
    var rejectArray = [String]()
    var rejectAnyArray = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromSource()
        
        
        
      
    }
    
    func accept(gesture: UITapGestureRecognizer) {
        if let v = gesture.view {
            print("it worked",v.tag)
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
            activityIndicator.activityIndicatorViewStyle = .gray
            activityIndicator.center = self.view.center
            activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            TransactionService.accept(transaction_id: v.tag, onCompletion: { statusCode, message in
               
                print("STATUSCODE",statusCode)
                
                TransactionDao.update(status: "ACCEPTED",transaction_id: v.tag)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    self.activityView.activityTableView.reloadData()
                    
                })
                
            })
            
        }
    }
    
    
    func rejected(gesture: UITapGestureRecognizer) {
        
        if let v = gesture.view {
            print("it worked",v.tag)
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
            activityIndicator.activityIndicatorViewStyle = .gray
            activityIndicator.center = self.view.center
            activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            
            
            
            TransactionService.reject(transaction_id: v.tag, onCompletion: { statusCode, message in
                
                print("STATUSCODE_REJECT",statusCode)
               
                TransactionDao.update(status: "REJECTED",transaction_id: v.tag)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                 self.activityView.activityTableView.reloadData()
                    
                     })
                
            })
            
        }
    
    }
    
    
    func completed(gesture: UITapGestureRecognizer) {
        
        if let v = gesture.view {
            print("it worked complete",v.tag)
            
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
            activityIndicator.activityIndicatorViewStyle = .gray
            activityIndicator.center = self.view.center
            activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            
            
            
            TransactionService.complete(transaction_id: v.tag, onCompletion: { statusCode, message in
                
                print("STATUSCODE_REJECT",statusCode)
                
                TransactionDao.update(status: "COMPLETED",transaction_id: v.tag)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    self.activityView.activityTableView.reloadData()
                    
                })
                
            })
            
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
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        TransactionService.fetchTransactions { (statusCode, message) in
           
            print(statusCode)
          
            if statusCode == 200 {
                
                let jsonObject: NSMutableDictionary = NSMutableDictionary()
                
                jsonObject.setValue("ONE", forKey: "b")
                jsonObject.setValue("TWO", forKey: "p")
                jsonObject.setValue("THREE", forKey: "o")
                jsonObject.setValue("FOUR", forKey: "s")
                jsonObject.setValue("FIVE", forKey: "r")
                
         
                
                let transaction = TransactionDao.getAllBuyers(buyer: true, status: "PENDING")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                print("TRANSACTIONDAO", transaction)
                self.transactions = transaction
                self.initUILayout()
                self.activityView.activityTableView.reloadData()
                    
                    })
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
        self.activityView.delegate = self
        self.activityView.activityTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        self.activityView.activityTableView.delegate = self
        self.activityView.activityTableView.dataSource = self
        
        //setupSegmentedControl()
    }
//    private func setupSegmentedControl(){
//        self.activityView.activitySegmentedControl.removeAllSegments()
//        self.activityView.activitySegmentedControl.insertSegment(withTitle: "Buying", at: 0, animated: false)
//        self.activityView.activitySegmentedControl.insertSegment(withTitle: "Selling", at: 1, animated: false)
//        self.activityView.activitySegmentedControl.insertSegment(withTitle: "History", at: 2, animated: false)
//    }
    
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
        
        
        if selectedSegment == 2 {
        cell.statusUIButton.setTitle( transactions[indexPath.item].status, for: .normal)
        cell.statusUIButton.setTitleColor(UIColor.white, for: .normal)
        cell.statusUIButton.isHidden = false
        cell.acceptUIButtonOutlet.isHidden = true
        cell.rejectUIButtonOutlet.isHidden = true
        cell.statusUIButton.isUserInteractionEnabled = false
            if self.transactions[indexPath.item].status == "REJECTED" || self.transactions[indexPath.item].status == "CANCELLED" {
            cell.statusUIButton.backgroundColor = UIColor.red
            }else{
            cell.statusUIButton.backgroundColor = UIColor.green
            
            }
            
        }else{
        
            cell.statusUIButton.isUserInteractionEnabled = true
            
            if self.transactions[indexPath.item].status == "ACCEPTED" {
                cell.statusUIButton.isHidden = false
                cell.statusUIButton.backgroundColor = UIColor.blue
                cell.statusUIButton.setTitleColor(UIColor.white, for: .normal)
                cell.statusUIButton.setTitle("COMPLETED", for: .normal)
                cell.acceptUIButtonOutlet.isHidden = true
                cell.rejectUIButtonOutlet.isHidden = true
                
            }else{
                cell.statusUIButton.isHidden = true
                cell.acceptUIButtonOutlet.isHidden = false
                cell.rejectUIButtonOutlet.isHidden = false
            
            }
           
        }
        
        
       
        
        
      if  self.transactions[indexPath.item].resource?.imageUrl != "" {
     
        cell.resourceUIImageView.kf.setImage(with: URL(string: (transactions[indexPath.item].resource?.imageUrl)!), options: [.transition(.fade(0.2))])
        
        }else{
        
        
         let url = URL(string: "http://theblackpanthers.com/s/photogallery/img/no-image-available.jpg")
        cell.resourceUIImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        
        }
        
        cell.acceptUIButtonOutlet.isUserInteractionEnabled = true
        cell.acceptUIButtonOutlet.tag = transactions[indexPath.row].id
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(ActivityViewController.accept))
        tapped.numberOfTapsRequired = 1
        cell.acceptUIButtonOutlet.addGestureRecognizer(tapped)
        
        cell.rejectUIButtonOutlet.isUserInteractionEnabled = true
        cell.rejectUIButtonOutlet.tag = transactions[indexPath.row].id
        
        let rejectTapped = UITapGestureRecognizer(target: self, action: #selector(ActivityViewController.rejected))
        rejectTapped.numberOfTapsRequired = 1
        cell.rejectUIButtonOutlet.addGestureRecognizer(rejectTapped)
        
        
        cell.statusUIButton.tag = transactions[indexPath.row].id
        
        let statusCompletedTapped = UITapGestureRecognizer(target: self, action: #selector(ActivityViewController.completed))
        statusCompletedTapped.numberOfTapsRequired = 1
        cell.statusUIButton.addGestureRecognizer(statusCompletedTapped)
       
        return cell
    }
}


// MARK: -ActivityViewDelegate
extension ActivityViewController: ActivityViewDelegate {
    func segmentedViewOnPressed(sender: AnyObject){
        selectedSegment = sender.selectedSegmentIndex
        print("SEGMENTED",sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0 {
            
            
            
            let transaction = TransactionDao.getAllBuyers(buyer: true, status: "PENDING")
           
                print("TRANSACTIONDAO", transaction)
                self.transactions = transaction
            
                self.activityView.activityTableView.reloadData()
                
            
        }else if sender.selectedSegmentIndex == 1 {
             let transactions = TransactionDao.getTransactions()
            //print("TRANS_ALL", transactions)
            let transaction = TransactionDao.getAllBuyers(buyer: false, status: "PENDING")
            
            print("TRANSACTIONDAO_SHARED", transaction)
            self.transactions = transaction
            
            self.activityView.activityTableView.reloadData()
            
        }else{
        
            let transaction = TransactionDao.getCompletedTransactions()
            
            print("TRANSACTIONDAO_HISTORY", transaction)
            self.transactions = transaction
            
            self.activityView.activityTableView.reloadData()
        
        }
        
     }
}
