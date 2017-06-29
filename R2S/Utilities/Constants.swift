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
        
        // MARK: - User
        struct user {
            static let base = api.baseUrl + "/users"
            static let one = user.base + "/{username}"
            static let register = user.base + "/register"
            static let login = user.base + "/login"
            static let changePassword = user.base + "/{username}/password"
            static let forgot = api.baseUrl + "/forgot"
            static let forgotCode = api.baseUrl + "/forgot/code"
        }
        
        // MARK: - Category
        struct category {
            static let base = api.baseUrl + "/categories"
            static let subCategory = category.base + "/{id}/subcategories"
        }
    }
    
    // MARK: - Xib Names
    struct xib {
        static let welcome = "WelcomeView"
        static let login = "LoginView"
        static let register = "RegisterView"
        static let home = "HomeView"
        static let resource = "ResourceView"
        
        // TableView Cell
        static let featuredTableCell = "FeaturedTableViewCell"
        static let categoryTableCell = "CategoryTableViewCell"
        
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
    }
}

