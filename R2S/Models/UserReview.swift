//
//  UserReview.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 16/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class UserReview: Object {
    
    dynamic var accountName = ""
    dynamic var id = 0
    dynamic var message = ""
    dynamic var rate = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
