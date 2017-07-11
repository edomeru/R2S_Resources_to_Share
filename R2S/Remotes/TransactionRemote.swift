//
//  CategoryRemote.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class TransactionRemote {
    static func fetchAll(onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.user.transactions.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
}
