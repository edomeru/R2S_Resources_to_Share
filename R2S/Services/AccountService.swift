//
//  AccountService.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 10/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON


class AccountService {

    static func changePassword(params: [String : Any], onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        
        UserRemote.change(id: String(UserHelper.getId()!),params: params, onCompletion: { jsonData, statusCode in
            if statusCode == 202 {
                print("Password CHANGE Successfully")
                message = "Password CHANGE Successfully"
                
            } else {
                message = jsonData["message"].stringValue
            }
            onCompletion(statusCode, message)
        })
    }
    
}
