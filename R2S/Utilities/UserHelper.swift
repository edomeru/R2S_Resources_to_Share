//
//  UserHelper.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class UserHelper {
    static let defaults = UserDefaults.standard
    
    // Getter
    static func getAccountId() -> String? {
        return UserHelper.defaults.string(forKey: "accountId")
    }
    
    static func getId() -> Int? {
        return UserHelper.defaults.integer(forKey: "id")
    }
    
    static func getFirstName() -> String? {
        return UserHelper.defaults.string(forKey: "firstName")
    }
    
    static func getLastName() -> String? {
        return UserHelper.defaults.string(forKey: "lastName")
    }
    
    static func getfullName() -> String? {
        return getFirstName()! + " " + getLastName()!
    }
    
    static func getUsername() -> String? {
        return UserHelper.defaults.string(forKey: "username")
    }
    
    static func getPassword() -> String? {
        return UserHelper.defaults.string(forKey: "password")
    }
    
    static func getEmail() -> String? {
        return UserHelper.defaults.string(forKey: "email")
    }
    
    static func getImageUrl() -> String? {
        return UserHelper.defaults.string(forKey: "imageUrl")
    }
    
    static func getCreatedDate() -> String? {
        return UserHelper.defaults.string(forKey: "createdDate")
    }
    
    static func getUpdatedDate() -> String? {
        return UserHelper.defaults.string(forKey: "updatedDate")
    }
    
    static func getIsLoggedIn() -> Bool? {
        return UserHelper.defaults.bool(forKey: "isLoggedIn")
    }
    static func getRole() -> String? {
        return UserHelper.defaults.string(forKey: "role")
    }
}
