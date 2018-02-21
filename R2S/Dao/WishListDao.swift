//
//  WishListDao.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 3/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class WishListDao{


static func get() -> Results<WishList> {
    let realm = try! Realm()
    let resource = realm.objects(WishList.self)
    return resource
}

    static func add(_ wishlist: WishList) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(wishlist, update: true)
        }
    }
    
    static func getOneBy(id: Int) -> WishList? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", id)
        let wish = realm.objects(WishList.self).filter(predicate).first
        return wish
    }

    static func getAllWishByUser(id: Int) -> Results<WishList> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "account.id = %d", id)
        let wish = realm.objects(WishList.self).filter(predicate)
        return wish
    }
    
    
    static func addWishListFromTags(_ wishlist: WishListTags) {
        print("addWishListFromTags",wishlist)
        let realm = try! Realm()
        try! realm.write {
            realm.add(wishlist, update: true)
        }
    }
    
    static func getWishListFromTags(subcategory_name: String) -> Results<WishListTags> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "subcategory_name = %@", subcategory_name)
        let wish = realm.objects(WishListTags.self).filter(predicate)
        return wish
    }
    
    static func getCategoryWishListFromTags(subcategory_name: String) -> Results<WishListTags> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "subcategory_name = %@", subcategory_name)
        let wish = realm.objects(WishListTags.self).filter(predicate)
        return wish
    }

}
