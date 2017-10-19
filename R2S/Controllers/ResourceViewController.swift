//
//  ResourceViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 18/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SwiftyJSON

class ResourceViewController: BaseViewController {
    
    var resourceView = ResourceView()
    var selectedResourceId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        
        self.fillUiWithData()
        
    }
    
    
    private func initUILayout() {
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.view = self.resourceView
        
        self.resourceView.delegate = self
    }
    
    private func fillUiWithData(){
        
        
        
        ResourceService.get{ (statusCode, message) in
            if statusCode == 200 {
                
                let resource =  ResourceService.getDetailView(id: 1)
                
                if let resourceDetail = resource {
                   
                    let placeholderImage = UIImage(named: "jong_suk")!
                    
                    for img in resourceDetail.image {
                         print("PAKYU ENZO!!!!", img.image)
                        
                        self.resourceView.resourceImageView.sd_setImage(with: URL(string:img.image), placeholderImage: placeholderImage, options: [.continueInBackground, .progressiveDownload])
                        
                    }
                    
                    
                    
                    self.resourceView.priceLabel.text  = "$ \(resourceDetail.price).00"
                    if let account = resourceDetail.account {
                        self.resourceView.nameLabel.text  = "\(account.first_name) \(account.last_name)"
                    }
                    
                    if let category = resourceDetail.categories.value(forKey: "main_category_name") {
                        print("BWAGAHHAHAHHAHA",category)
                        self.resourceView.categoryLabel.text  = " \(category)"
                    }
                    
                    self.resourceView.phoneLabel.text  = resourceDetail.account?.mobile_number
                    self.resourceView.emailLabel.text  = resourceDetail.account?.email
                    self.resourceView.titleSubLabel.text  = resourceDetail.name
                }
            }
        }
        
    }
    
}

extension ResourceViewController: ResourceViewDelegate {
    
    
}

