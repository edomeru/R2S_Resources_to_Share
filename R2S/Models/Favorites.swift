//
//  Favorites.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 12/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Favorites: Object {
    
    dynamic var id = 0
    dynamic var resource = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["resource"]
    }
    
}