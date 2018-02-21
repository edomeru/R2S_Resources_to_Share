//
//  ConversationDao.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 7/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift


class ConversationDao {

    static func add(_ conversation: Conversation) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(conversation, update: true)
        }
    }
    
    static func getAll() -> Results<Conversation> {
        let realm = try! Realm()
        let convo = realm.objects(Conversation.self)
        return convo
    }
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            let categories = realm.objects(Conversation.self)
            realm.delete(categories)
        }
    }


}
