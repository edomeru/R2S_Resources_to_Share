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
import TTGSnackbar
import SwiftHEXColors

class ActivityViewController: BaseViewController {

    var activityView = ActivityView()
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var selectedSegment: Int?
    var screenHeight: CGFloat!
    var transactions: Results<Transaction>!
    var selectedCategoryId: Int!
    var selectedTransactionId:Int = 0
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
            
            alertConfirmation(title: "Confirm", message: "Do you really want this item to be accepted?", status: "ACCEPT", transaction_id: v.tag)

        }
    }
    
    
    func rejected(gesture: UITapGestureRecognizer) {
        
        if let v = gesture.view {
            print("it worked",v.tag)
            
            
            alertConfirmation(title: "Confirm", message: "Do you really want this item to be rejected?", status: "REJECT", transaction_id: v.tag)
        }
    
    }
    
    
    func completed(gesture: UITapGestureRecognizer) {
        
        
        if let v = gesture.view {
            print("it worked complete",v.tag)
            alertConfirmation(title: "Confirm", message: "Do you really want this item to be completed?", status: "COMPLETE", transaction_id: v.tag)
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
    
    
    func alertConfirmation(title: String, message:String, status: String, transaction_id: Int) {
    
        let dialogMessage = UIAlertController(title: title , message: message , preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            if status == "COMPLETE" {
                self.doComplete(transaction_id: transaction_id)
            }else if status == "REJECT" {
                 self.doReject(transaction_id: transaction_id)
            }else if status == "ACCEPT" {
                self.doAccept(transaction_id: transaction_id)
            }
            
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)

    
    }
    
    func doComplete(transaction_id: Int){
                    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
                    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
                    activityIndicator.activityIndicatorViewStyle = .gray
                    activityIndicator.center = self.view.center
                    activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
                    activityIndicator.center = self.view.center
                    activityIndicator.hidesWhenStopped = true
                    self.view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
        
        
        
        
                    TransactionService.complete(transaction_id: transaction_id, onCompletion: { statusCode, message in
        
                        print("STATUSCODE_REJECT",statusCode)
        
                        TransactionDao.update(status: "COMPLETED",transaction_id: transaction_id)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            activityIndicator.stopAnimating()
                            self.activityView.activityTableView.reloadData()
        
        
        
        
        Utility.showSnackBAr(messege:"Item has been completed", bgcolor: UIColor(hexString: Constants.color.primary)!)
                        })
                        
                    })

    }
    
    func doReject(transaction_id: Int){
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        
        
        TransactionService.reject(transaction_id: transaction_id , onCompletion: { statusCode, message in
            
            print("STATUSCODE_REJECT",statusCode)
            
            TransactionDao.update(status: "REJECTED",transaction_id: transaction_id)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                activityIndicator.stopAnimating()
                self.activityView.activityTableView.reloadData()
                
                Utility.showSnackBAr(messege:"Item has been rejected", bgcolor: UIColor(hexString: Constants.color.redSnackBar)!)
                
            })
            
        })
    
    }
    
    func doAccept(transaction_id: Int){
    
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        TransactionService.accept(transaction_id: transaction_id, onCompletion: { statusCode, message in
            
            print("STATUSCODE",statusCode)
            
            TransactionDao.update(status: "ACCEPTED",transaction_id: transaction_id)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                activityIndicator.stopAnimating()
                self.activityView.activityTableView.reloadData()
                Utility.showSnackBAr(messege:"Item has been accepted", bgcolor: UIColor(hexString: Constants.color.greenSnackBar)!)
                
            })
            
        })
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
            case Constants.segue.activityViewToTrasactionView:
                let destinationVC = segue.destination as! TransactionViewController
                destinationVC.selectedTransactionId = selectedTransactionId
              
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.item]
        if let cell = tableView.cellForRow(at: indexPath) {
            
            
            selectedTransactionId  = transaction.id
            print("TRANS_ID",transaction.id)
            self.performSegue(withIdentifier: Constants.segue.activityViewToTrasactionView, sender: self)
        }
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
            cell.statusUIButton.backgroundColor = UIColor(hexString: Constants.color.redSnackBar)!
            }else{
            cell.statusUIButton.backgroundColor = UIColor(hexString: Constants.color.greenSnackBar)!
            
            }
            
        }else{
        
            cell.statusUIButton.isUserInteractionEnabled = true
            
            if self.transactions[indexPath.item].status == "ACCEPTED" {
                cell.statusUIButton.isHidden = false
                cell.statusUIButton.backgroundColor = UIColor(hexString: Constants.color.primary)!
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
