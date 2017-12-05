//
//  LastMessege.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class LastMessege: Object {

    dynamic var id = 0
    dynamic var message = ""
    dynamic var date_created = ""
    dynamic var author_id = 0
    dynamic var account_name = ""
    dynamic var account_image_url = ""
    dynamic var is_read = false
   
    
    override static func primaryKey() -> String? {
        return "id"
    }

}
