//
//  FavoritesDao.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 12/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritesDao {
    
    
    static func isFavorite(id: Int) -> Bool? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", id)
        let user = realm.objects(Favorites.self).filter(predicate).first
        if ((user) != nil){
            return true
        }
        
        return false
    }
    
    static func add(_ category: Favorites) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
        }
    }
    
    static func addResource(_ category: Resource) {
    
        let realm = try! Realm()
        try! realm.write {
            realm.add(category, update: true)
        }
    }
    
    static func get() -> Results<Favorites> {
        let realm = try! Realm()
        let favorites = realm.objects(Favorites.self)
        return favorites
    }
    
    static func getOneBy(id: Int) -> Favorites? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", id)
        let fav = realm.objects(Favorites.self).filter(predicate).first
        return fav
    }
    
    static func delete(_ fav: Favorites) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(fav)
        }
    }

    
}
