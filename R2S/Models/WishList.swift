//
//  WishList.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 3/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class WishList: Object {
    
    
    dynamic var id = 0
    dynamic var descriptionText = ""
    dynamic var name = ""
    dynamic var account: Account?
    //dynamic var company: Account?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
