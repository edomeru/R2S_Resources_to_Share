//
//  ConversationRemote.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 6/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON

class ConversationRemote{
    
    static func byId(message_id: String, onCompletion: @escaping (JSON, Int?) -> Void) {
        
        if let user_id = UserHelper.getId(){
        var urlString = Constants.api.user.message_by_id.replacingOccurrences(of: "{id}", with: String(describing: user_id ))
            
            urlString =  urlString.replacingOccurrences(of: "{message_id}", with: message_id)
            print("CONVO_URL",urlString)
            ApiRequestManager.sharedInstance.doGetRequest(urlString: urlString, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
                onCompletion(jsonData, statusCode)
            })
            
        }
       
    }
    
    
    static func reply(conversation_id: String, params: [String : Any], onCompletion: @escaping (JSON, Int?) -> Void) {
        
         if let user_id = UserHelper.getId(){
        var urlString = Constants.api.user.reply.replacingOccurrences(of: "{id}", with: String(describing: user_id))
        urlString = urlString.replacingOccurrences(of: "{message_id}", with: String(describing: conversation_id))
        print("REPLY_URL",urlString)
        ApiRequestManager.sharedInstance.doPostRequest(urlString: urlString, params: params, headers: Utility.getHeadersWithAuth(), onCompletion: { jsonData, statusCode in
            onCompletion(jsonData, statusCode)
        })
        }
    }
    
    
}
