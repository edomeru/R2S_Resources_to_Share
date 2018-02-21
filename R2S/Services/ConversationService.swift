//
//  ConversationService.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 6/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class ConversationService {

    static func getMessages(messageId: Int,onCompletion: @escaping (Int?, String?) -> Void) {
        
        var message = ""
        ConversationRemote.byId(message_id: "\(messageId)", onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                 print("TEST ConversationService", jsonData)
                print("TEST_Conversation_statusCode", statusCode)
                if statusCode == 200 {
                    message = ""
                   
                    for (_, chat):(String, JSON) in jsonData {
                   let convo =  Conversation()
                         convo.convo_id = IncrementaID()
                convo.id = chat["id"].intValue
                convo.author_id = chat["author_id"].intValue
                convo.account_name = chat["account_name"].stringValue
                convo.date_created =  chat["date_created"].stringValue
                convo.is_read = chat["is_read"].boolValue
                convo.message = chat["message"].stringValue
                convo.account_image_url = chat["account_image_url"].stringValue
                    
                ConversationDao.add(convo)
                    }
                } else {
                    message = jsonData["message"].stringValue
                }
                    
            }
            
            DispatchQueue.main.async {
                onCompletion(statusCode, message)
            }
        })
    }
    
    
    static func sendMessage(conversation_id: Int, params: [String : Any], onCompletion: @escaping (Int?, String?) -> Void) {
        var message: String?
        ConversationRemote.reply(conversation_id: "\(conversation_id)", params : params , onCompletion: { jsonData, statusCode in
            print("JSONDATE", jsonData)
            DispatchQueue.global(qos: .background).async {
                
                
                message = jsonData["message"].stringValue
                
            }
            
            DispatchQueue.main.async {
                onCompletion(statusCode, jsonData["message"].stringValue)
            }
        })
    }

}

//Increment ID
func IncrementaID() -> Int{
    let realm = try! Realm()
    if let retNext = realm.objects(Conversation.self).sorted(byKeyPath: "convo_id").last?.convo_id {
        return retNext + 1
    }else{
        return 1
    }
}

