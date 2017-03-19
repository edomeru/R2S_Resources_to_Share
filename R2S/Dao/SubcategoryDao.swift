//
//  SubcategoryDao.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class SubcategoryDao {
    static func getSubcategories() -> Results<Subcategory> {
        let realm = try! Realm()
        let subcategories = realm.objects(Subcategory.self)
        return subcategories
    }
    
    static func getOneBy(subcategoryId: Int) -> Subcategory? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", subcategoryId)
        let subcategory = realm.objects(Subcategory.self).filter(predicate).first
        return subcategory
    }
    
    static func add(_ subcategory: Subcategory) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(subcategory, update: true)
        }
    }
    
    static func edit(_ category: Category, keys: [String], values: [Any?]) {
        let realm = try! Realm()
        for item in 0..<keys.count {
            try! realm.write {
                category.setValue(values[item], forKey: keys[item])
            }
        }
    }
    
    static func delete(_ category: Category) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(category)
        }
    }
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            let categories = realm.objects(Category.self)
            realm.delete(categories)
        }
    }
}
