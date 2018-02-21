//
//  TransactionViewViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 4/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import Foundation

class TransactionViewController: BaseViewController {
    
    var transactionView = TransactionView()
    var selectedTransactionId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      initUILayout()
        
        print("selectedTransactionId",selectedTransactionId)
        self.title = "View Transaction"
        
      let item = TransactionDao.getOneBy(transactionId: selectedTransactionId)
        
        self.transactionView.dateEndUILabel.text = item?.bookingEndDate
        self.transactionView.dateStartUILabel.text = item?.bookingStartDate
        self.transactionView.ordernumUILabel.text = item?.referenceCode
        if let price = item?.resource?.price {
        self.transactionView.priceUILabel.text = String(describing: price)
        }
        self.transactionView.statusUILabel.text = item?.status
        self.transactionView.quantityUILabel.text = item?.quantity
        self.transactionView.messageUILabel.text = item?.proposal
        self.transactionView.itemPicUIImageView.kf.setImage(with:  URL(string: (item?.resource?.imageUrl)!), placeholder: nil)
        self.transactionView.resourceNameUILabel.text = item?.resource?.name
        self.transactionView.descriptionUILabel.text = item?.resource?.descriptionText
        
        
         print(item?.seller?.first_name)
         print("NAME",item?.seller?.last_name)
        
        
        
        self.transactionView.namePersonUILabel.text = (item?.seller?.first_name)! + " " + (item?.seller?.last_name)!
        
       
    }

    private func initUILayout() {

        self.transactionView = self.loadFromNibNamed(nibNamed: Constants.xib.transactionView) as! TransactionView
        self.view = self.transactionView
       
        
        
    }

  

}
