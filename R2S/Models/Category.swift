//
//  Category.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    dynamic var id = 0
    dynamic var descriptionText = ""
    dynamic var imageUrl = ""
    dynamic var name = ""
    dynamic var status = ""
    dynamic var isSelected = false
    let subcategories = List<Subcategory>()
    dynamic var createdDate = ""
    dynamic var updatedDate = ""
    dynamic var deletedDate = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}
