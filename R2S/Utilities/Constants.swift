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
        static let baseUrl = "http://api.r2s.tirsolutions.com/resources-to-share/api"
        
//        static let baseUrl =  "http://stagingapi.r2s.tirsolutions.com/resources-to-share-stg/api"
        
        // MARK: - User
        struct user {
            static let base = api.baseUrl + "/users"
            static let users = api.baseUrl + "/users/{id}"
            static let one = user.base + "/{username}"
            static let register = user.base + "/register"
            static let login = user.base + "/login"
            static let changePassword = user.base + "/{username}/password"
            static let forgot = api.baseUrl + "/forgot"
            static let forgotCode = api.baseUrl + "/forgot/code"
            static let change = users + "/password"
            
            // MARK: - Transaction
            static let transactions = base + "/{id}/transactions"
            static let transaction = transactions + "/{transaction_id}"
            static let transaction_reject = transaction + "/reject"
            static let transaction_complete = transaction + "/complete"
            static let transaction_rate = transaction + "/rate"
            static let profile_details = base + "/{id}"
             // MARK: - Wishlisy
            static let  wishlist = base + "/{id}/wishlists"
            // MARK: - Resources
            static let resources =  base + "/{id}/resources";
            
            // MARK: - favorites
            static let favorites =  resources + "/favorites";
            
            // MARK: - favorites
            static let inbox =  base + "/{id}/messages";
            
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
        
        struct System {
        static let UPLOAD = api.baseUrl + "/upload/images"
            
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
         static let searchView = "SearchView"
        static let favoritesView = "FavoritesView"
        static let wishlistView = "WishlistView"
        static let resourceView = "ResourceView"
        static let NewResourceView = "NewResourceView"
        static let wishlistDetailView = "WishListDetailView"
        static let inboxView = "InboxView"
        static let wishlistAddView = "WishListAddView"
        static let transactionView = "transactionView"
        static let EditProfile = "EditProfile"
        static let ChangePasswordView = "ChangePasswordView"
        static let AppSettingsView = "AppSettingsView"
        static let RaiseSupportTicketView = "RaiseSupportTicketView"
        static let ScheduleBookingView = "ScheduleBookingView"
        // TableView Cell
        static let featuredTableCell = "FeaturedTableViewCell"
        static let categoryTableCell = "CategoryTableViewCell"
        static let resourceTableCell = "ResourceTableViewCell"
        static let favoritesTableCell = "FavoritesTableViewCell"
        static let wishListTableViewCell = "WishListTableViewCell"
        static let inboxTableViewCell = "InboxTableViewCell"
        static let ProfileTableViewCell = "ProfileTableViewCell"
        static let SearchTableViewCell = "SearchTableViewCell"
        
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
        static let redSnackBar = "E53935"
        static let greenSnackBar = "66BB6A"
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
        static let activityViewToTrasactionView = "activityViewToTrasactionView"
        static let profileToWelcomeSegue = "profileToWelcomeSegue"
        static let profileToEditProfileSegue = "profileToEditProfileSegue"
        static let profileToChangePasswordSegue = "profileToChangePasswordSegue"
        static let profileToAppSettingsSegue = "profileToAppSettingsSegue"
        static let profileToRaiseSupportTicketSegue = "profileToRaiseSupportTicketSegue"
        static let resourceViewToScheduleBookingSegue = "resourceViewToScheduleBookingSegue"
        static let HomeViewToSearchViewSegue = "HomeViewToSearchViewSegue"
        static let SearchToResourceSegue = "SearchToResourceSegue"
        
    }
}

