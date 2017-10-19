//
//  ResourceDao.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 11/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class ResourceDao {
   
    
    static func getByAccountId(accountId: String) -> Results<Resource> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", accountId)
        let resource = realm.objects(Resource.self).filter(predicate)
        return resource
    }
    
    
    static func get() -> Results<Resource> {
        let realm = try! Realm()
        let resource = realm.objects(Resource.self)
        return resource
    }
    
    
    static func getByCategoryId(id: Int) -> Results<Resource>{
        let realm = try! Realm()
        let predicate = NSPredicate(format: "category.id = %d", id)
        let resource = realm.objects(Resource.self).filter(predicate)
        return resource
    }
    
    static func getBySubcategoryId(id: Int) -> Results<Resource> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "categories.subcategory.id = %d", id)
        let resource = realm.objects(Resource.self).filter(predicate)
        return resource
    }
    static func add(_ category: Resource) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
        }
    }
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            let categories = realm.objects(Resource.self)
            realm.delete(categories)
        }
    }
}
