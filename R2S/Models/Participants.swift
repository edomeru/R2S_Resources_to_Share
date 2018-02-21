//
//  Participants.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift


class Participants: Object {

    dynamic var id = 0
    dynamic var account_id = 0
    dynamic var account_name = ""
    dynamic var account_image_url = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
