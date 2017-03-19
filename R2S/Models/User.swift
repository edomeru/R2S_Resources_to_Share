//
//  User.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var accountId = ""
    dynamic var birthDate = ""
    dynamic var email = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var isSubscribed = false
    dynamic var imageUrl = ""
    dynamic var landlineNumber = ""
    dynamic var mobileNumber = ""
    dynamic var password = ""
    dynamic var status = ""
    dynamic var createdDate = ""
    dynamic var updatedDate = ""
    dynamic var deletedDate = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["email", "accountId"]
    }
    
    override static func ignoredProperties() -> [String] {
        return ["password"]
    }
}
