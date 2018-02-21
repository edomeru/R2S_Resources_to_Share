//
//  WishListDetailedViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 4/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift


class WishlistDetailViewController: BaseViewController {

    var selectedWishListId: Int?
    var wishlistDetailView = WishlistDetailView()
    var wish: WishList?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("selectedWishListId",selectedWishListId)
        
        fetchData()
        
        
    }
    
    private func fetchData(){
         wish =  WishListDao.getOneBy(id: selectedWishListId!)
        if (wish != nil) {
             print("WISHLIST",wish)
         initUILayout()
        
        }
       
    
    }
    
    
    private func initUILayout() {
     
        
        self.wishlistDetailView = self.loadFromNibNamed(nibNamed: Constants.xib.wishlistDetailView) as! WishlistDetailView
        self.view = self.wishlistDetailView
        
        wishlistDetailView.name.text = wish?.name
         wishlistDetailView.descriptionUILabel.text = wish?.descriptionText
       wishlistDetailView.company.text = wish?.account?.company?.name
        wishlistDetailView.nameOfOwner.text = "\(wish?.account?.first_name)" + " " + "\(wish?.account?.last_name)"
        
        
    }

}
