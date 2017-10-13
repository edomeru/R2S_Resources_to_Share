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
                if statusCode == 200{
                  print("JSONDATA" + "\(jsonData)"  )
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
                        newResource.account = resource["account"].stringValue
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

                        // show realm database file
                        //print(Realm.Configuration.defaultConfiguration.fileURL!)

                        
                        ResourceDao.add(newResource)
                         //print("LOOB" + "\(newResource)"  )
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
                        let newResource = Resource()
                        newResource.id = resource["id"].intValue
                        newResource.resourceCode = resource["resourceCode"].stringValue
                        newResource.snapshotCode = resource["snapshotCode"].stringValue
                        newResource.imageUrl = resource["image_url"].stringValue
                        newResource.createdDate = resource["createdDate"].stringValue
                        newResource.resourceRate = resource["resourceRate"].stringValue
                        newResource.name = resource["name"].stringValue
                        newResource.descriptionText = resource["descriptionText"].stringValue
                        newResource.account = resource["account"].stringValue
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                       // newResource.location = resource["location"].stringValue
                        
                        
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
                        let newResource = Resource()
                        newResource.id = resource["id"].intValue
                        newResource.resourceCode = resource["resourceCode"].stringValue
                        newResource.snapshotCode = resource["snapshotCode"].stringValue
                        newResource.imageUrl = resource["image_url"].stringValue
                        newResource.createdDate = resource["createdDate"].stringValue
                        newResource.resourceRate = resource["resourceRate"].stringValue
                        newResource.name = resource["name"].stringValue
                        newResource.descriptionText = resource["descriptionText"].stringValue
                        newResource.account = resource["account"].stringValue
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                       // newResource.location = resource["location"].stringValue
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
                        newResource.account = resource["account"].stringValue
                        newResource.price = resource["price"].stringValue
                        newResource.quantity = resource["quantity"].stringValue
                        newResource.status = resource["status"].stringValue
                        //newResource.location = resource["location"].stringValue
                      
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

    
    static func createResource(resource_id: Int, params: [String: AnyObject], onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        UserRemote.createResource(resource_id: "\(resource_id)", params : params , onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
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
                        newResource.account = resource["account"].stringValue
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
    
}
