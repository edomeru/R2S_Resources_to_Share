//
//  MessageParam.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 10/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class MessageParam: Object {
    dynamic var resourceId = 0
    dynamic var id = 0
    dynamic var message = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
