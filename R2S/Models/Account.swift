//
//  Account.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 13/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    
    dynamic var seller_rating = ""
    dynamic var status = ""
    dynamic var company: Company?
    dynamic var birth_date = ""
    dynamic var landline_number = ""
    dynamic var created_date = ""
    let buyer_reviews = List<UserReview>()
    dynamic var mobile_number = ""
    dynamic var updated_date = ""
    dynamic var last_name = ""
    dynamic var is_subscribed = false
    dynamic var id = 0
     let roles = List<Roles>()
    dynamic var email = ""
    let seller_review = List<UserReview>()
    dynamic var account_id = ""
    dynamic var deleted_date = ""
    dynamic var first_name = ""
    dynamic var buyer_rating = 0
    dynamic var image_url = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
   
}
