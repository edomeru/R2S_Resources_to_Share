//
//  InboxDao.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift


class InboxDao {


    static func getAll() -> Results<Inbox> {
        let realm = try! Realm()
        let inbox = realm.objects(Inbox.self)
        return inbox
    }
    
    static func add(_ inbox: Inbox) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(inbox, update: true)
        }
    }
    

}
