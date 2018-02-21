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
    
    
    static func accept(transaction_id: Int, onCompletion: @escaping (JSON, Int?) -> Void) {
        var urlString = Constants.api.user.transaction.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        urlString = urlString.replacingOccurrences(of: "{transaction_id}", with: String(transaction_id))
        print("accept_url",urlString)
        ApiRequestManager.sharedInstance.doPutRequest(urlString: urlString,  headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func reject(transaction_id: Int, onCompletion: @escaping (JSON, Int?) -> Void) {
        var urlString = Constants.api.user.transaction_reject.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        urlString = urlString.replacingOccurrences(of: "{transaction_id}", with: String(transaction_id))
        print("reject_url",urlString)
        ApiRequestManager.sharedInstance.doPostRequestNoParam(urlString: urlString,  headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func complete(transaction_id: Int, onCompletion: @escaping (JSON, Int?) -> Void) {
        var urlString = Constants.api.user.transaction_complete.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        urlString = urlString.replacingOccurrences(of: "{transaction_id}", with: String(transaction_id))
        print("complete_url",urlString)
        ApiRequestManager.sharedInstance.doPostRequestNoParam(urlString: urlString,  headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func create(params:  [String: Any], onCompletion: @escaping (JSON, Int?) -> Void) {
        var urlString = Constants.api.user.transactions.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        
        print("create_url",urlString)
        ApiRequestManager.sharedInstance.doPostRequest(urlString: urlString, params:params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
    static func selling(onCompletion: @escaping (JSON, Int?) -> Void) {
        let urlString = Constants.api.user.selling.replacingOccurrences(of: "{id}", with: String(describing: UserHelper.getId()!))
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }

    static func getAgreement(reference_code: String, onCompletion: @escaping (JSON, Int?) -> Void) {
        var urlString = Constants.api.agreement_url.replacingOccurrences(of: "{reference_code}", with: String(describing: reference_code))
        
        print("agreement_url",urlString)
        ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
    }
    
}
