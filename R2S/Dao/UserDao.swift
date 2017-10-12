//
//  UserDao.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class UserDao {
    static func add(_ user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    static func getOneBy(email: String) -> User? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email = %@", email.lowercased())
        let user = realm.objects(User.self).filter(predicate).first
        return user
    }
    
    static func getOneBy(id: Int) -> User? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", id)
        let user = realm.objects(User.self).filter(predicate).first
        return user
    }
    
    static func delete(_ user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(user)
        }
    }
}
