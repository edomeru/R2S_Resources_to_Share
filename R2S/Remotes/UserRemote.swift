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
    
    static func resources(id: String, onCompletion: @escaping (JSON, Int?) -> Void) {
        ApiRequestManager.sharedInstance.doGetRequest(urlString: Constants.api.user.resources.replacingOccurrences(of: "{id}", with: String(describing: id )), headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func favorites(id: String, onCompletion: @escaping (JSON, Int?) -> Void) {
        //print("REMOTE URL",Constants.api.user.favorites.replacingOccurrences(of: "{id}", with: String(describing: id )))
        ApiRequestManager.sharedInstance.doGetRequest(urlString: Constants.api.user.favorites.replacingOccurrences(of: "{id}", with: String(describing: id )), headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func getProfile(id: Int, onCompletion: @escaping (JSON, Int?) -> Void) {
        ApiRequestManager.sharedInstance.doGetRequest(urlString: Constants.api.user.profile_details.replacingOccurrences(of: "{id}", with: String(describing: id )), headers: Utility.getHeaders(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func createResource(id: String,params: [String: Any], onCompletion: @escaping (JSON, Int?) -> Void) {
        print("BWAGAHHAHAHAHHA "+Constants.api.user.resources.replacingOccurrences(of: "{id}", with: String(describing: id )))
        ApiRequestManager.sharedInstance.doPostRequest(urlString: Constants.api.user.resources.replacingOccurrences(of: "{id}", with: String(describing: id )), params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func createWishList(id: String,params: [String: AnyObject], onCompletion: @escaping (JSON, Int?) -> Void) {
        print("createWishList PARAMS",params)
        ApiRequestManager.sharedInstance.doPostRequest(urlString: Constants.api.user.wishlist.replacingOccurrences(of: "{id}", with: String(describing: id )), params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func change(id: String,params: [String: Any], onCompletion: @escaping (JSON, Int?) -> Void) {
        print("PARAMS",params)
        ApiRequestManager.sharedInstance.doPutRequestWithParam(urlString: Constants.api.user.change.replacingOccurrences(of: "{id}", with: String(describing: id )), params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func update(params: [String: Any], onCompletion: @escaping (JSON, Int?) -> Void) {
        print("PARAMS",params)
        print("URL",Constants.api.user.users.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!)))
        ApiRequestManager.sharedInstance.doPutRequestWithParam(urlString: Constants.api.user.users.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()! )), params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
}
