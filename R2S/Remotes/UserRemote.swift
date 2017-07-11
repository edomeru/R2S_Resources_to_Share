//
//  UserRemote.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserRemote {
    static func register(_ params: [String: AnyObject], onCompletion: @escaping (JSON, Int?) -> Void) {
        ApiRequestManager.sharedInstance.doPostRequestNoAuth(urlString: Constants.api.user.register, params: params, headers: Utility.getHeaders(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func login(_ params: [String: AnyObject], onCompletion: @escaping (JSON, Int?) -> Void) {
        ApiRequestManager.sharedInstance.doPostRequestNoAuth(urlString: Constants.api.user.login, params: params, headers: Utility.getHeaders(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
}
