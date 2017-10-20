//
//  ResourceSubcategory.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 20/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class ResourceSubcategory: Object {
    dynamic var id = 0
    dynamic var descriptionText = ""
    dynamic var imageUrl = ""
    dynamic var name = ""
    dynamic var status = ""
    dynamic var createdDate = ""
  
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
