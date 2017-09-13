//
//  CategoryDao.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class CategoryDao {
    static func getCategories() -> Results<Category> {
        let realm = try! Realm()
        let categories = realm.objects(Category.self)
        return categories
    }
    
    static func getOneBy(categoryId: Int) -> Category? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", categoryId)
        let category = realm.objects(Category.self).filter(predicate).first
        return category
    }
    
    static func add(_ category: Category) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
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
