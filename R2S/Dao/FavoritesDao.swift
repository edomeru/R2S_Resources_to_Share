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
    
}
