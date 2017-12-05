//
//  Inbox.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Inbox: Object {

    dynamic var id = 0
    let participants = List<Participants>()
    dynamic var name = ""
    dynamic var date_created = ""
    dynamic var status = ""
    dynamic var last_message: LastMessege?
    dynamic var resource:InboxResource?
    dynamic var message_count = 0
    dynamic var unread_message_count = 0
   
    override static func primaryKey() -> String? {
        return "id"
    }
}
