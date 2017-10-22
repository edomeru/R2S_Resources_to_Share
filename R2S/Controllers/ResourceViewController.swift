//
//  ResourceViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 18/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SwiftyJSON
import Auk
import moa

class ResourceViewController: BaseViewController {
    
    var resourceView = ResourceView()
    var selectedResourceId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        
        self.fillUiWithData()
        
        print(selectedResourceId)
        
    }
    
    
    private func initUILayout() {
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.view = self.resourceView
        
        self.resourceView.delegate = self
    }
    
    private func fillUiWithData(){
        
        
        
//        ResourceService.get{ (statusCode, message) in
//            if statusCode == 200 {
        
                let resource =  ResourceService.getDetailView(id: self.selectedResourceId)
                
                if let resourceDetail = resource {
                   
                    
                    for img in resourceDetail.image {
                         //print("IMAGE!!!", img.image)
                        
                        self.resourceView.scrollView.auk.show(url: img.image)
                        
                    }
                    
                    resourceView.scrollView.auk.settings.contentMode = .scaleAspectFit
                    Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy
  
                    
                    self.resourceView.priceLabel.text  = "$ \(resourceDetail.price).00"
                    if let account = resourceDetail.account {
                        self.resourceView.nameLabel.text  = "\(account.first_name) \(account.last_name)"
                    }

                    for category in resourceDetail.categories {
                        //print("CATEGORY!!!!", category.main_category_name)
//                        
//                       self.resourceView.categoryLabel.text  = category.main_category_name
//                        
                    }
                    
                    self.resourceView.phoneLabel.text  = resourceDetail.account?.mobile_number
                    self.resourceView.emailLabel.text  = resourceDetail.account?.email
                    self.resourceView.titleSubLabel.text  = resourceDetail.name
                }
            
    }
    
}

extension ResourceViewController: ResourceViewDelegate {
    
    
}

