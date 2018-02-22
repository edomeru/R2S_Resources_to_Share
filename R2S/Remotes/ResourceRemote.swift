//
//  ResourceRemote.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 11/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResourceRemote{

    static func get(onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.resource.unArchived.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeaders(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }

    static func addToFavorites(resource_id: String, params: [String:AnyObject], onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.resource.resource_favorites.replacingOccurrences(of: "{resource_id}", with: String(describing: resource_id))
        ApiRequestManager.sharedInstance.doPostRequest(urlString: urlString, params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })

    }
    static func removeFavoriteObject(params: [String:AnyObject], onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.user.favorites.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        print("REMOVE_FAV",urlString)
        ApiRequestManager.sharedInstance.doDeleteRequest(urlString: urlString, params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
        
    }
    
    
    static func byCategory(categoty_id: String, onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.user.transactions.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
      

}
