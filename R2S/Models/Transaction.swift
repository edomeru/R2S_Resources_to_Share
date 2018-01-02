//
//  Category.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Transaction: Object {
    

    dynamic var id = 0
    dynamic var referenceCode = ""
    dynamic var proposal = ""
    dynamic var bookingStartDate = ""
    dynamic var bookingEndDate = ""
    dynamic var createdDate = ""
   
    dynamic var buyer = ""
    dynamic var quantity = ""
    dynamic var resource: Resource?
    dynamic var seller = ""
    dynamic var status = ""
    dynamic var is_buyer = false
   
    override static func primaryKey() -> String? {
        return "id"
    }


}
