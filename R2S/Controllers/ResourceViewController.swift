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
import Floaty

class ResourceViewController: BaseViewController {
    
    var resourceView = ResourceView()
    var selectedResourceId: Int = 0
    var floaty = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("selectedResourceId",selectedResourceId)
        
        self.initUILayout()
        self.fillUiWithData()
        
        print("ResourceViewController")
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segue.resourceViewToScheduleBookingSegue:
                let destinationVC = segue.destination as! ScheduleBookingViewController
                destinationVC.selectedResourceId = selectedResourceId
                
            case "resourceViewToChatSegue" :
                let destinationVC = segue.destination as! ChatViewController
                destinationVC.selectedChatId = selectedResourceId
                
            default:
                print("default");
            }
        }
    }
    
    
    private func initUILayout() {
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.view = self.resourceView
        
        self.resourceView.delegate = self
         floaty.fabDelegate = self
        floaty.addItem(title: "Hello, World!")
        floaty.buttonColor = UIColor(hexString: Constants.color.primaryDark)!
        floaty.buttonImage = UIImage(named: "ic_event_available_white")
        self.resourceView.addSubview(floaty)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.resourceView.sendMsgUIImageView.isUserInteractionEnabled = true
        self.resourceView.sendMsgUIImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       performSegue(withIdentifier: "resourceViewToChatSegue", sender: self)
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

extension ResourceViewController: FloatyDelegate {
    
    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
        
        performSegue(withIdentifier: "resourceViewToScheduleBookingSegue", sender: self)
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
        self.floaty.close()
        
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
    }
    
    
    
}

