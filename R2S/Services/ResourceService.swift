//
//  ResourceService.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 11/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class ResourceService {
    /////////////////////////////////////////////////////////////
    //
    //      Network / API Related Services
    //
    /////////////////////////////////////////////////////////////
    
    static func get(onCompletion: @escaping(Int?, String?) -> Void){
        var message = ""
        ResourceRemote.get(onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async{
                if statusCode == 200 {
                  //print("JSONDATA" + "\(jsonData)"  )
                    message = ""
                    for (_, resource):(String, JSON) in jsonData {
                        let newResource = Resource()
                        newResource.id = resource["id"].intValue
                        newResource.resourceCode = resource["resource_code"].stringValue
                        newResource.snapshotCode = resource["snapshot_code"].stringValue
                        newResource.imageUrl = resource["image_url"].stringValue
                        newResource.createdDate = resource["created_date"].stringValue
                        newResource.resourceRate = resource["resource_rate"].stringValue
                        newResource.name = resource["name"].stringValue
                        newResource.descriptionText = resource["description"].stringValue
                       
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                        
                        
                        //Images
                        for (_, image):(String, JSON) in resource["images"] {
                            let img = Image()
                            img.image = image["image"].stringValue
                            img.imageFull = image["image_full"].stringValue
                           
                            newResource.image.append(img)
                        }
                        
                        //Location
                        let loc = resource["location"]
                        let location = Location()
                        location.zipcode = loc["zipcode"].stringValue
                        location.state = loc["state"].stringValue
                        location.latitude = loc["latitude"].stringValue
                        location.city = loc["city"].stringValue
                        location.longitude = loc["longitude"].stringValue
                        location.street = loc["street"].stringValue
                        
                        newResource.location = location

                        
                        //Account
                        let accnt = resource["account"]
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
                        
                        //Roles
                  
                            for (_, role):(String, JSON) in accnt["roles"] {
//                                let roles = Roles()
//                                
//                                account.roles.append((role as? Roles)!)
                            }
                       
                        
                        //Buyer & Seller Reviews
                        
                        for (_, seller_review):(String, JSON) in accnt["seller_reviews"] {
                            let seller = UserReview()
                            seller.id = seller_review["id"].intValue
                            seller.accountName = seller_review["accountName"].stringValue
                            seller.message = seller_review["message"].stringValue
                            seller.rate = seller_review["rate"].stringValue
                            
                            account.seller_review.append(seller)
                        }


                        
                        newResource.account = account
                        
                        // show realm database file
                        //print(Realm.Configuration.defaultConfiguration.fileURL!)

                        
                        
                        
                        
                        
                        //Categories
                        for (_, categories):(String, JSON) in resource["categories"] {
                            let cat = Categories()
                            cat.main_category_id = categories["main_category_id"].intValue
                            cat.main_category_name = categories["main_category_name"].stringValue
                            
                            let subCat = categories["subcategory"]
                            let sub = Subcategories()
                            sub.created_date = subCat["created_date"].stringValue
                            sub.id = subCat["id"].intValue
                            sub.status = subCat["status"].stringValue
                            sub.image_url = subCat["image_url"].stringValue
                            sub.name = subCat["name"].stringValue
                            sub.descriptionText = subCat["description"].stringValue
                            
                            cat.subcategories = sub
                            
                            newResource.categories.append(cat)
                        }
                        
                        ResourceDao.add(newResource)
                         print("LOOB" + "\(newResource)"  )
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
    
    static func getByAccount(id: Int,onCompletion: @escaping (Int?, String?) -> Void) {
        
        var message = ""
        UserRemote.resources(id: "\(id)", onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                    message = ""
                    for (_, resource):(String, JSON) in jsonData {
//                        print("TEST BWAHAHHAHA ", jsonData)
                        let newResource = Resource()
                        newResource.id = resource["id"].intValue
                        newResource.resourceCode = resource["resource_code"].stringValue
                        newResource.snapshotCode = resource["snapshot_code"].stringValue
                        newResource.imageUrl = resource["image_url"].stringValue
                        newResource.createdDate = resource["created_date"].stringValue
                        newResource.resourceRate = resource["resource_rate"].stringValue
                        newResource.name = resource["name"].stringValue
                        newResource.descriptionText = resource["description"].stringValue
                        
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                        
                        
                        //Images
                        for (_, image):(String, JSON) in resource["images"] {
                            let img = Image()
                            img.image = image["image"].stringValue
                            img.imageFull = image["image_full"].stringValue
                            
                            newResource.image.append(img)
                        }
                        
                        //Location
                        let loc = resource["location"]
                        let location = Location()
                        location.zipcode = loc["zipcode"].stringValue
                        location.state = loc["state"].stringValue
                        location.latitude = loc["latitude"].stringValue
                        location.city = loc["city"].stringValue
                        location.longitude = loc["longitude"].stringValue
                        location.street = loc["street"].stringValue
                        
                        newResource.location = location

                        
                        //Categories
                        for (_, categories):(String, JSON) in resource["categories"] {
                            let cat = Categories()
                            cat.main_category_id = categories["main_category_id"].intValue
                            cat.main_category_name = categories["main_category_name"].stringValue
                            
                            let subCat = categories["subcategory"]
                            let sub = Subcategories()
                            sub.created_date = subCat["created_date"].stringValue
                            sub.id = subCat["id"].intValue
                            sub.status = subCat["status"].stringValue
                            sub.image_url = subCat["image_url"].stringValue
                            sub.name = subCat["name"].stringValue
                            sub.descriptionText = subCat["description"].stringValue
                            
                            cat.subcategories = sub
                            
                            newResource.categories.append(cat)
                        }
                        
                        ResourceDao.deleteAll()
                        ResourceDao.add(newResource)
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
    
    static func getFavorites(id: Int,onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        UserRemote.resources(id: "\(id)", onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                    message = ""
                    for (_, resource):(String, JSON) in jsonData {
                        //                        print("TEST BWAHAHHAHA ", jsonData)
                        let newResource = Resource()
                        newResource.id = resource["id"].intValue
                        newResource.resourceCode = resource["resource_code"].stringValue
                        newResource.snapshotCode = resource["snapshot_code"].stringValue
                        newResource.imageUrl = resource["image_url"].stringValue
                        newResource.createdDate = resource["created_date"].stringValue
                        newResource.resourceRate = resource["resource_rate"].stringValue
                        newResource.name = resource["name"].stringValue
                        newResource.descriptionText = resource["description"].stringValue
                        
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                        
                        
                        //Images
                        for (_, image):(String, JSON) in resource["images"] {
                            let img = Image()
                            img.image = image["image"].stringValue
                            img.imageFull = image["image_full"].stringValue
                            
                            newResource.image.append(img)
                        }
                        
                        //Location
                        let loc = resource["location"]
                        let location = Location()
                        location.zipcode = loc["zipcode"].stringValue
                        location.state = loc["state"].stringValue
                        location.latitude = loc["latitude"].stringValue
                        location.city = loc["city"].stringValue
                        location.longitude = loc["longitude"].stringValue
                        location.street = loc["street"].stringValue
                        
                        newResource.location = location
                        
                        
                        //Categories
                        for (_, categories):(String, JSON) in resource["categories"] {
                            let cat = Categories()
                            cat.main_category_id = categories["main_category_id"].intValue
                            cat.main_category_name = categories["main_category_name"].stringValue
                            
                            let subCat = categories["subcategory"]
                            let sub = Subcategories()
                            sub.created_date = subCat["created_date"].stringValue
                            sub.id = subCat["id"].intValue
                            sub.status = subCat["status"].stringValue
                            sub.image_url = subCat["image_url"].stringValue
                            sub.name = subCat["name"].stringValue
                            sub.descriptionText = subCat["description"].stringValue
                            
                            cat.subcategories = sub
                            
                            newResource.categories.append(cat)
                        }
                        
                        let favorite = Favorites()
                        favorite.id = resource["id"].intValue
                        FavoritesDao.isFavorite(id: favorite.id)
                        ResourceDao.deleteAll()
                        ResourceDao.add(newResource)
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

    static func addToFavorites(resource_id: Int, params: [String: AnyObject], onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        ResourceRemote.addToFavorites(resource_id: "\(resource_id)", params : params , onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                } else {
                    message = jsonData["message"].stringValue
                }
            }
            
            DispatchQueue.main.async {
                onCompletion(statusCode, message)
            }
        })
    }

    
    static func createResource(id: Int, params: [String: AnyObject], onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        UserRemote.createResource(id: "\(id)", params: params, onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                    print(jsonData)
                    message = ""
                    for (_, resource):(String, JSON) in jsonData {
                        let newResource = Resource()
                        newResource.id = resource["id"].intValue
                        newResource.resourceCode = resource["resourceCode"].stringValue
                        newResource.snapshotCode = resource["snapshotCode"].stringValue
                        newResource.imageUrl = resource["image_url"].stringValue
                        newResource.createdDate = resource["createdDate"].stringValue
                        newResource.resourceRate = resource["resourceRate"].stringValue
                        newResource.name = resource["name"].stringValue
                        newResource.descriptionText = resource["descriptionText"].stringValue
                        
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                       // newResource.location = resource["location"].stringValue
                        
                        ResourceDao.add(newResource)
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
    
    /////////////////////////////////////////////////////////////
    //
    //      Database / DAO Related Services
    //
    /////////////////////////////////////////////////////////////

    
    
    
    
    
}
