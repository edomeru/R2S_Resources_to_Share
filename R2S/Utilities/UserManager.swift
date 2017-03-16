//
//  UserManager.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class UserManager {
    static let sharedInstance = UserManager()
    
    var id: Int!
    var accountId: String!
    var password: String!
    var firstName: String!
    var lastName: String!
    var fullName: String!
    var email: String!
    var createdDate: String!
    var updatedDate: String!
    var isLoggedIn: Bool!
    
    private init() {
        let defaults = UserDefaults.standard
        self.id = defaults.integer(forKey: "id")
        self.password = KeychainWrapper.standard.string(forKey: "password")
        self.accountId =  defaults.string(forKey: "accountId")
        self.firstName = defaults.string(forKey: "firstName")
        self.lastName = defaults.string(forKey: "lastName")
        self.email =  defaults.string(forKey: "email")
        self.createdDate = defaults.string(forKey: "createdDate")
        self.updatedDate = defaults.string(forKey: "updatedDate")
        self.isLoggedIn = defaults.bool(forKey: "isLoggedIn")
    }
}
