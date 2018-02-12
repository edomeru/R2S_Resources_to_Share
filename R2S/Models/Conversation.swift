//
//  Conversation.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 7/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Conversation: Object {

    
    dynamic var convo_id = 0
    dynamic var id = 0
    dynamic var account_name = ""
    dynamic var is_read = false
    dynamic var author_id = 0
    dynamic var message = ""
    dynamic var date_created = ""
    dynamic var account_image_url = ""
    
    override static func primaryKey() -> String? {
        return "convo_id"
    }





}
