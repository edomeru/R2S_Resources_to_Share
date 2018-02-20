//
//  InboxRemote.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class InboxRemote {
    static func fetchAll(id: Int , onCompletion: @escaping (JSON, Int?) -> Void) {
        var urlString = Constants.api.user.inbox.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        print("LINK",urlString)
        ApiRequestManager.sharedInstance.doGetRequest(urlString: Constants.api.user.inbox.replacingOccurrences(of: "{id}", with: String(describing: id )), headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }

}
