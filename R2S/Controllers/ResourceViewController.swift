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
        print("selectedResourceId",selectedResourceId)
        
        self.initUILayout()
        self.fillUiWithData()
        
        print("ResourceViewController")
        
        
    }
    
    
    private func initUILayout() {
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.view = self.resourceView
        
        self.resourceView.delegate = self
        
        
    }
    
    private func fillUiWithData(){
        
        
        
              let f = FavoritesDao.getOneBy(id: self.selectedResourceId)
        if f != nil {
           //print("favoritesDetail",f)
            
            if let resourceDetail = f {
                
                print("resourceDetail!!!", resourceDetail)
                for img in resourceDetail.image {
                    //print("IMAGE!!!", img.imageFull)
                    
                    
                    self.resourceView.scrollView.auk.show(url: img.imageFull)
                    
                }
                
                resourceView.scrollView.auk.settings.contentMode = .scaleAspectFit
                Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy
                
                
                self.resourceView.priceLabel.text  = "$ \(resourceDetail.price).00"
                if let account = resourceDetail.account {
                    let processor = RoundCornerImageProcessor(cornerRadius: 20)
                    self.resourceView.nameLabel.text  = "\(account.first_name) \(account.last_name)"
                    
                    self.resourceView.accountImagePickerView.kf.setImage(with:  URL(string: account.image_url), placeholder: nil, options: [.processor(processor)])
                    
                    
                }
                
                self.resourceView.descriptionText.text = f?.descriptionText
                for category in resourceDetail.categories {
                    //print("CATEGORY!!!!", category.main_category_name)
                    //
                    //                       self.resourceView.categoryLabel.text  = category.main_category_name
                    //                        for sub in category.subcategory {
                    //
                    //                        }
                    //
                }
                
                if resourceDetail.account?.mobile_number != "" {
                
                self.resourceView.phoneLabel.text  = resourceDetail.account?.mobile_number
                    
                }
                
                self.resourceView.emailLabel.text  = resourceDetail.account?.email
                self.resourceView.titleSubLabel.text  = resourceDetail.name
            }
            
            
            
        
            
            ///END
        }  else {
                let resource =  ResourceService.getDetailView(id: self.selectedResourceId)
                print("resourceDetail",resource)
                if let resourceDetail = resource {
                   
                    print("resourceDetail!!!", resourceDetail)
                    for img in resourceDetail.image {
                         print("IMAGE!!!", img.imageFull)
                        
                       
                        self.resourceView.scrollView.auk.show(url: img.imageFull)
                        
                    }
                    
                    resourceView.scrollView.auk.settings.contentMode = .scaleAspectFit
                    Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy
  
                    
                    self.resourceView.priceLabel.text  = "$ \(resourceDetail.price).00"
                    if let account = resourceDetail.account {
                        let processor = RoundCornerImageProcessor(cornerRadius: 20)
                        self.resourceView.nameLabel.text  = "\(account.first_name) \(account.last_name)"
                      
                        self.resourceView.accountImagePickerView.kf.setImage(with:  URL(string: account.image_url), placeholder: nil, options: [.processor(processor)])
                        
                        
                    }

                    self.resourceView.descriptionText.text = resource?.descriptionText
                    for category in resourceDetail.categories {
                        //print("CATEGORY!!!!", category.main_category_name)
//                        
//                       self.resourceView.categoryLabel.text  = category.main_category_name
//                        for sub in category.subcategory {
//                        
//                        }
//                        
                    }
                    
                    self.resourceView.phoneLabel.text  = resourceDetail.account?.mobile_number
                    self.resourceView.emailLabel.text  = resourceDetail.account?.email
                    self.resourceView.titleSubLabel.text  = resourceDetail.name
                }
        
        }
            
    }
    
}

extension ResourceViewController: ResourceViewDelegate {
    
    
}

