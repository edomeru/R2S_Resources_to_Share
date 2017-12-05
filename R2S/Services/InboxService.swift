//
//  InboxService.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON


class InboxService {

    static func getAll(id: Int , onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        InboxRemote.fetchAll(id: id , onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                    message = ""
                    
                    for (_, message):(String, JSON) in jsonData {
                        let inbox = Inbox()
                        inbox.id = message["id"].intValue
                        inbox.name = message["name"].stringValue
                        inbox.date_created = message["date_created"].stringValue
                        inbox.status = message["status"].stringValue
                        inbox.message_count = message["message_count"].intValue
                        inbox.unread_message_count = message["unread_message_count"].intValue
                        
                        for (_, participants):(String, JSON) in message["participants"] {
                            let participant = Participants()
                            participant.id = participants["id"].intValue
                            participant.account_id = participants["account_id"].intValue
                            participant.account_name = participants["account_name"].stringValue
                            participant.account_image_url = participants["account_image_url"].stringValue
                            
                            inbox.participants.append(participant)
                        }
                        
                            let l_msg = message["last_message"]
                            let lastMessage = LastMessege()
                            lastMessage.id = l_msg["id"].intValue
                            lastMessage.message = l_msg["message"].stringValue
                            lastMessage.date_created = l_msg["date_created"].stringValue
                            lastMessage.account_image_url = l_msg["account_image_url"].stringValue
                            lastMessage.author_id = l_msg["author_id"].intValue
                            lastMessage.account_name = l_msg["account_name"].stringValue
                            lastMessage.is_read = l_msg["is_read"].boolValue
                        
                            inbox.last_message = lastMessage
                        
                        let i_resource = message["resource"]
                        let inbox_resource = InboxResource()
                        inbox_resource.id = i_resource["id"].intValue
                        inbox_resource.name = i_resource["name"].stringValue
                        inbox_resource.image_url = i_resource["image_url"].stringValue
                        inbox_resource.price = i_resource["price"].intValue
                        
                        
                        inbox.resource = inbox_resource

                        
                        print("INBOX DAO",inbox)
                        InboxDao.add(inbox)
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


}
