//
//  SystemService.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 31/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class SystemService {
    
    static func upload(params: [String:Any] , onCompletion: @escaping (Int?, JSON?) -> Void) {
        var message = ""

        SystemRemote.upload(params: params, onCompletion: { jsonData, statusCode in
            print("STATCODE",statusCode)
            if statusCode == 201 {
                message = "Upload successful."
                print("JSONDATA",jsonData)
            } else {
                message = jsonData["message"].stringValue
            }
            onCompletion(statusCode, jsonData)
        })
    }
    
}
