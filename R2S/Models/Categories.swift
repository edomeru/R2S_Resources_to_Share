//
//  Categories.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 16/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object {

    dynamic var main_category_id = 0
    dynamic var main_category_name = ""
    dynamic var subcategories : Subcategories?
  
    
    override static func primaryKey() -> String? {
        return "main_category_id"
    }
    
    
}
