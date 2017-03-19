//
//  CategoryService.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class CategoryService {
    /////////////////////////////////////////////////////////////
    //
    //      Network / API Related Services
    //
    /////////////////////////////////////////////////////////////
    
    static func fetchCategories(onCompletion: @escaping (Int?, String?) -> Void) {
        var message = ""
        CategoryRemote.fetchAll(onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                if statusCode == 200 {
                    message = ""
                    for (_, category):(String, JSON) in jsonData {
                        let newCategory = Category()
                        newCategory.id = category["id"].intValue
                        newCategory.name = category["name"].stringValue
                        newCategory.descriptionText = category["description"].stringValue
                        newCategory.imageUrl = category["image_url"].stringValue
                        newCategory.status = category["status"].stringValue
                        newCategory.isSelected = false
                        CategoryDao.add(newCategory)
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
    
    static func getCategories() -> Results<Category> {
        let categories = CategoryDao.getCategories()
        return categories
    }
    
    static func selectCategory(_ category: Category) {
        CategoryDao.edit(category, keys: ["isSelected"], values: [true])
    }
    
    static func clearSelectedCategories(_ categories: Results<Category>) {
        for category in categories {
            CategoryDao.edit(category, keys: ["isSelected"], values: [false])
        }
    }
}
