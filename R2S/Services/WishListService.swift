//
//  WishListService.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 3/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON


class WishListService {
    
    static func getAllWishList(onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        WishListRemote.fetchAll(onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                    message = ""
                    print("WISHLIST SERVICE" + "\(jsonData)"  )
                    for (_, wishlist):(String, JSON) in jsonData {
                        let wishList = WishList()
                        wishList.id = wishlist["id"].intValue
                        wishList.name = wishlist["name"].stringValue
                        wishList.descriptionText = wishlist["description"].stringValue
                        
                        
                        
                        //Account
                        let accnt = wishlist["account"]
                        let account = Account()
                        account.seller_rating = accnt["seller_rating"].stringValue
                        account.status = accnt["status"].stringValue
                        
                        account.birth_date = accnt["birth_date"].stringValue
                        account.landline_number = accnt["landline_number"].stringValue
                        account.created_date = accnt["created_date"].stringValue
                        
                        account.mobile_number = accnt["mobile_number"].stringValue
                        account.updated_date = accnt["updated_date"].stringValue
                        account.last_name = accnt["last_name"].stringValue
                        
                        account.is_subscribed = accnt["is_subscribed"].boolValue
                        account.id = accnt["id"].intValue
                        account.email = accnt["email"].stringValue
                        account.account_id = accnt["account_id"].stringValue
                        account.deleted_date = accnt["deleted_date"].stringValue
                        account.first_name = accnt["first_name"].stringValue
                        account.buyer_rating = accnt["buyer_rating"].intValue
                        account.image_url = accnt["image_url"].stringValue
                        
                        wishList.account = account
                        print("WISHLIST DAO",wishList)
                        WishListDao.add(wishList)
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
    
    
    
    static func createWishlist(category: [String : AnyObject], name: String, description: String, onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        var params: [String : AnyObject] = [:]
        params["name"] = name as AnyObject?
        params["description"] = description as AnyObject?
        params["categories"] = category as AnyObject?
        
        UserRemote.createWishList(id: String(UserHelper.getId()!),params: params, onCompletion: { jsonData, statusCode in
            if statusCode == 200 {
                print("WishList Added Successfully")
                message = "WishList Added Successfully"
                
            } else {
                message = jsonData["message"].stringValue
            }
            onCompletion(statusCode, message)
        })
    }
    
    
}
