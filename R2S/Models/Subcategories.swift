//
//  Subcategories.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 16/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Subcategories: Object {
    
    dynamic var created_date = ""
    dynamic var id = 0
    dynamic var status = ""
    dynamic var image_url = ""
    dynamic var name = ""
    dynamic var descriptionText = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
