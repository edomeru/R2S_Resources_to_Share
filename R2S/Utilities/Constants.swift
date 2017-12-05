//
//  Constants.swift
//  R2S
//
//  Created by Earth Maniebo on 14/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

class Constants {
    
    static let navbarHeight = CGFloat(64.0)
    
    // MARK: - API Endpoints
    struct api {
//        static let baseUrl = "http://api.r2s.tirsolutions.com/resources-to-share/api"
        
        static let baseUrl =  "http://stagingapi.r2s.tirsolutions.com/resources-to-share-stg/api"
        
        // MARK: - User
        struct user {
            static let base = api.baseUrl + "/users"
            static let one = user.base + "/{username}"
            static let register = user.base + "/register"
            static let login = user.base + "/login"
            static let changePassword = user.base + "/{username}/password"
            static let forgot = api.baseUrl + "/forgot"
            static let forgotCode = api.baseUrl + "/forgot/code"
            
            // MARK: - Transaction
            static let transactions = base + "/{id}/transactions"
            static let transaction = transactions + "/{transaction_id}"
            static let transaction_reject = transaction + "/reject"
            static let transaction_complete = transaction + "/complete"
            static let transaction_rate = transaction + "/rate"
            static let profile_details = base + "/{id}"
             // MARK: - Resources
            static let  wishlist = base + "/{id}/wishlists"
            // MARK: - Resources
            static let resources =  base + "/{id}/resources";
            
            // MARK: - Resources
            static let favorites =  resources + "/favorites";
        }
        
        // MARK: - Category
        struct category {
            static let base = api.baseUrl + "/categories"
            static let subCategory = base + "/{id}/subcategories"
        }
        
        struct resource {
            static let base = api.baseUrl + "/resources"
            static let category_id = base + "/category?id={category_id}"
            static let unArchived = base + "?mode=unarchived"
            static let subCategory_id = base + "/subcategory?id={subcategory_id}"
            static let selected = base + "/{id}"
            static let snapShot_code = base + "/references/{snapshot_code}"
            static let resource_favorites = base + "/{resource_id}/favorites"
        }
        
        struct wishlists {
        static let base = api.baseUrl + "/wishlists"
        }
        
    }
    
    // MARK: - Xib Names
    struct xib {
        static let welcome = "WelcomeView"
        static let login = "LoginView"
        static let register = "RegisterView"
        static let homeView = "HomeView"
        static let activityView = "ActivityView"
        static let accountView = "AccountView"
        static let browseView = "BrowseView"
        static let favoritesView = "FavoritesView"
        static let wishlistView = "WishlistView"
        static let resourceView = "ResourceView"
        static let NewResourceView = "NewResourceView"
        static let wishlistDetailView = "WishListDetailView"
        
        // TableView Cell
        static let featuredTableCell = "FeaturedTableViewCell"
        static let categoryTableCell = "CategoryTableViewCell"
        static let resourceTableCell = "ResourceTableViewCell"
        static let favoritesTableCell = "FavoritesTableViewCell"
        static let wishListTableViewCell = "WishListTableViewCell"
        
        // CollectionView Cell
        static let categoryCollectionCell = "CategoryCollectionViewCell"
        static let subcategoryCollectionCell = "SubCategoryCollectionViewCell"

        
        // Scroll views
        static let featuredCarouselItem = "FeaturedCarouselItemView"
    }
    
    // MARK: - Colors
    struct color {
        static let primary = "008DE7"
        static let primaryDark = "0070DD"
        static let accent = "4C4C4C"
        static let background = "DDDDDD"
        static let white = "FFFFFF"
        static let transparentWhite = "77FFFFFF"
        static let black = "000000"
        static let charade = "282B35"
        static let athensGray = "F0EFF5"
        static let electricBlue = "168EE2"
        static let charcoal = "414340"
        static let astralBlue = "3A6994"
        static let grayUnderline = "9E9E9E"
    }
    
    // MARK: - Segue Identifiers
    struct segue {
        static let welcomeToLogin = "WelcomeToLoginSegue"
        static let welcomeToRegister = "WelcomeToRegisterSegue"
        static let welcomeToHome = "WelcomeToHomeSegue"
        static let loginToHome = "LoginToHomeSegue"
        static let homeToResourceSegue = "HomeToResourceSegue"
        static let homeToWishlistSegue = "HomeToWishlistSegue"
        static let homeToFavoritesSegue = "HomeToFavoritesSegue"
        static let browseToResourceSegue  = "BrowseToResourceSegue"
        static let wishToWishListDetailSegue  = "WishToWishListDetailSegue"
    }
}

