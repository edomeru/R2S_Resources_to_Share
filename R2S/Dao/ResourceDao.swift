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
   
    
    static func getByAccountId(accountId: Int) -> Results<Resource> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "account.id = %d", accountId)
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
        let predicate = NSPredicate(format: "ANY categories.main_category_id = %d", id)
        let resource = realm.objects(Resource.self).filter(predicate)
        return resource
    }
    
    static func getBySubcategoryId(id: Int) -> Results<Resource> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "ANY categories.subcategory.id = %d", id)
        let resource = realm.objects(Resource.self).filter(predicate)
       
        return resource
    }
    
    static func getByCatIdAndSubCatId(catId: Int, subCatId: Int) -> Results<Resource> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "ANY categories.main_category_id = %d AND ANY categories.subcategory.id = %d", catId, subCatId)
        let resource = realm.objects(Resource.self).filter(predicate)
        
        return resource
    }
    
    static func add(_ category: Resource) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
        }
    }
    
    static func addSubCategoryALL(_ category: Subcategory) {
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
    
    static func getOneBy(id: Int) -> Resource? {
        print("RESOURCE ID", id)
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", id)
        let user = realm.objects(Resource.self).filter(predicate).first
        return user
    }
}
