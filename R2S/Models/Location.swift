//
//  Location.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 13/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    dynamic var zipcode = ""
    dynamic var state = ""
    dynamic var latitude = ""
    dynamic var city = ""
    dynamic var longitude = ""
    dynamic var street = ""
}
