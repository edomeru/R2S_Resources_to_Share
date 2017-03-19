//
//  CategoryRemote.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryRemote {
    static func fetchAll(onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.category.base
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
}
