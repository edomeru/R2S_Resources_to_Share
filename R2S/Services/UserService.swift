//
//  UserService.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class UserService {
    /////////////////////////////////////////////////////////////
    //
    //      Network / API Related Services
    //
    /////////////////////////////////////////////////////////////

    static func register(_ user: User, onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        var params: [String: AnyObject] = [:]
        params["email"] = user.email as AnyObject?
        params["first_name"] = user.firstName as AnyObject?
        params["last_name"] = user.lastName as AnyObject?
        params["password"] = user.password as AnyObject?
        params["is_subscribed"] = user.isSubscribed as AnyObject?
        
        UserRemote.register(params, onCompletion: { jsonData, statusCode in
            if statusCode == 201 {
                message = "Registration successful."
            } else {
                message = jsonData["message"].stringValue
            }
            onCompletion(statusCode, message)
        })
    }
    
   
    

    static func login(email: String, password: String, onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        var params: [String: AnyObject] = [:]
        params["email"] = email as AnyObject?
        params["password"] = password as AnyObject?
        UserRemote.login(params, onCompletion: { jsonData, statusCode in
            if statusCode == 200 {
                print("jsonDataUSER",jsonData)
                message = "Login successful."
                let user = User()
                user.accountId = jsonData["account_id"].stringValue
                user.id = jsonData["id"].intValue
                user.firstName = jsonData["first_name"].stringValue
                user.lastName = jsonData["last_name"].stringValue
                user.email = jsonData["email"].stringValue
                user.birthDate = jsonData["birth_date"].stringValue
                user.mobileNumber = jsonData["mobile_number"].stringValue
                user.landlineNumber = jsonData["landline_number"].stringValue
                user.designation = jsonData["designation"].stringValue
                user.descriptionText = jsonData["description"].stringValue
                user.imageUrl = jsonData["image_url"].stringValue
                user.status = jsonData["status"].stringValue
                user.isSubscribed = jsonData["is_subscribed"].boolValue
                user.createdDate = jsonData["created_date"].stringValue
                user.updatedDate = jsonData["updated_date"].stringValue
                user.deletedDate = jsonData["deleted_date"].stringValue
                
                //Account
                let cmpy = jsonData["company"]
                let company = Company()
                company.name = cmpy["name"].stringValue
               
                
                
                
                user.company = company
                
                
                
                
                
                
                KeychainWrapper.standard.set(password, forKey: "password")
                
                let defaults = UserDefaults.standard
                defaults.setValue(user.accountId, forKey: "accountId")
                defaults.setValue(user.id, forKey: "id")
                defaults.setValue(user.firstName, forKey: "firstName")
                defaults.setValue(user.lastName, forKey: "lastName")
                defaults.setValue(password, forKey: "password")
                defaults.setValue(user.email, forKey: "email")
                defaults.setValue(user.birthDate, forKey: "birthDate")
                defaults.setValue(user.mobileNumber, forKey: "mobileNumber")
                defaults.setValue(user.landlineNumber, forKey: "landlineNumber")
                defaults.setValue(user.isSubscribed, forKey: "isSubscribed")
                defaults.setValue(user.imageUrl, forKey: "imageUrl")
                defaults.setValue(user.createdDate, forKey: "createdDate")
                defaults.setValue(user.updatedDate, forKey: "updatedDate")
                defaults.setValue(true, forKey: "isLoggedIn")
                UserDao.add(user)
            } else {
                message = jsonData["message"].stringValue
            }
            onCompletion(statusCode, message)
        })
    }
    
    
    static func createTransaction(_ params: [String: Any], onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
      
        
        TransactionRemote.create(params: params, onCompletion: { jsonData, statusCode in
            if statusCode == 201 {
                message = "Successfully booked"
            } else {
                message = jsonData["message"].stringValue
            }
            onCompletion(statusCode, message)
        })
    }
}
