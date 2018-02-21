//
//  WishListTags.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 11/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class WishListTags: Object {
    
    
    dynamic var id = 0
    dynamic var main_category_name = ""
    dynamic var main_category_id = 0
    dynamic var subcategory_name = ""
    dynamic var subcategory_id = 0
    
    
    override  static func primaryKey() -> String? {
        return "id"
    }
    
   
    
}
