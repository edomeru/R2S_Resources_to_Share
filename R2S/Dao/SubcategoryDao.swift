//
//  SubcategoryDao.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class SubcategoryDao {
    
   
    
    
    static func getSubcategoriesBy(categoryId: Int) -> Results<Subcategory> {
        let realm = try! Realm()
        var subcategories: Results<Subcategory>?
        
        let predicate = NSPredicate(format: "parentCategory.id = %d", categoryId)
        subcategories = realm.objects(Subcategory.self).filter(predicate)
        print("ssssssss", subcategories!)
        return subcategories!
    }
    
    static func getSubcategoriesByWithALL(categoryId: Int, lastIndex: Int) -> Results<Subcategory> {
        let realm = try! Realm()
        var subcategories: Results<Subcategory>?
        print("lastIndex", lastIndex)
        let predicate = NSPredicate(format: "parentCategory.id = %d OR parentCategory.id = %d",categoryId,lastIndex)
        subcategories = realm.objects(Subcategory.self).filter(predicate).sorted(byKeyPath: "parentCategory.id", ascending: false)
                print("NBBBIUBUH", subcategories!)
        return subcategories!
    }
    
    
    
    static func getOneBy(subcategoryId: Int) -> Subcategory? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", subcategoryId)
        let subcategory = realm.objects(Subcategory.self).filter(predicate).first
        return subcategory
    }
    static func getAllBySubCategoryName(categoryId: Int, subCategoryName: String) -> Results<Subcategory> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "parentCategory.id = %d AND name = %@", categoryId, subCategoryName)
        let subcategories = realm.objects(Subcategory.self).filter(predicate)
        return subcategories
    }
    
    static func add(_ subcategory: Subcategory) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(subcategory, update: true)
        }
    }
    
    
    
    static func edit(_ subcategory: Subcategory, keys: [String], values: [Any?]) {
        let realm = try! Realm()
        for item in 0..<keys.count {
            try! realm.write {
                subcategory.setValue(values[item], forKey: keys[item])
            }
        }
    }
    
    static func delete(_ subcategory: Subcategory) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(subcategory)
        }
    }
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            let subcategories = realm.objects(Subcategory.self)
            realm.delete(subcategories)
        }
    }
}
