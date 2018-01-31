//
//  HomeTabBarViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(hex: Constants.color.primary)
        self.configureNavBar()
        
    }

    func configureNavBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        let imgFavorites   = UIImage(named: "ic_favorite_border")!
        let imgWishlist = UIImage(named: "ic_card_giftcard")!
        
        let favoritesButton   = UIBarButtonItem(image: imgFavorites,  style: .plain, target: self, action: #selector(self.favoritesOnButtonPressed))
        let wishlistButton = UIBarButtonItem(image: imgWishlist,  style: .plain, target: self, action: #selector(self.wishlistOnButtonPressed))
        
        // set to black
        favoritesButton.tintColor = UIColor.white
        wishlistButton.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItems = [favoritesButton, wishlistButton]
    }
    
    func favoritesOnButtonPressed(){
        print("faovirtes")
        performSegue(withIdentifier: Constants.segue.homeToFavoritesSegue, sender: self)
    }
    
    func wishlistOnButtonPressed(){
        print("wishlist")
        performSegue(withIdentifier: Constants.segue.homeToWishlistSegue, sender: self)
    }
}

