//
//  WishListRemote.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 3/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON


class WishListRemote {

    static func fetchAll(onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.wishlists.base
        print("WishListURL",urlString)
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }


}
