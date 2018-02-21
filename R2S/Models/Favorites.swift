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
    var resource = List<Resource>()
    
    dynamic var resourceCode = ""
    dynamic var snapshotCode = ""
    dynamic var imageUrl = ""
    dynamic var createdDate = ""
    dynamic var resourceRate = ""
    let image = List<Image>()
    var categories = List<ResourceCategory>()
    dynamic var name = ""
    dynamic var descriptionText = ""
    dynamic var price = ""
    dynamic var quantity = ""
    dynamic var status = ""
    dynamic var location: Location?
    dynamic var account: Account?
    
    
    
    func getId() -> Int {
        return id
    }
    
    func setId(id: Int) {
         self.id = id
    }
    
    func getResource() ->  List<Resource> {
        return self.resource
    }
    
    func setResource(resource: List<Resource> ) {
        self.resource = resource
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["resource"]
    }
    
}
