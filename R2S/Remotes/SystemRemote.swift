//
//  SystemRemote.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 31/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class SystemRemote {


    static func upload(params: [String:Any], onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.System.UPLOAD
        print("SYSTEM_ENDPOINT", urlString)
        ApiRequestManager.sharedInstance.doPostRequest(urlString: urlString, params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
        
    }




}
