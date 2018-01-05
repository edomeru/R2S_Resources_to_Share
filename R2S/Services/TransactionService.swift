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

class TransactionService {
    
    /////////////////////////////////////////////////////////////
    //
    //      Network / API Related Services
    //
    /////////////////////////////////////////////////////////////

    
    static func fetchTransactions(onCompletion: @escaping(Int?, String?) -> Void){
        var message = ""
        TransactionRemote.fetchAll(onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async{
                if statusCode == 200{
                    print("TRANSERVICE",jsonData)
                    print("++++++++++++++++++++++++++++++")
                    for (_, transactions):(String, JSON) in jsonData {
                                      print(transactions)
                        let transaction = Transaction()
                        transaction.id = transactions["id"].intValue
                        transaction.referenceCode = transactions["reference_code"].stringValue
                        transaction.proposal = transactions["proposal"].stringValue
                        
                        
                        transaction.bookingStartDate = Utility.dateToString(dateString: Utility.stringToDate(dateString: transactions["booking_start_date"].stringValue))
                        
                        transaction.bookingEndDate = Utility.dateToString(dateString: Utility.stringToDate(dateString: transactions["booking_end_date"].stringValue))
                        transaction.createdDate = transactions["created_date"].stringValue
                        transaction.buyer = transactions["buyer"].stringValue
                        transaction.quantity = transactions["quantity"].stringValue
                        
                        
                        let resources = transactions["resource"]
                        let res = Resource()
                        
                        
                       print("DATEEEEEE",Utility.dateToString(dateString: Utility.stringToDate(dateString: resources["created_date"].stringValue))) 
                        
                        res.price = "$"  + resources["price"].stringValue
                        res.createdDate = Utility.dateToString(dateString: Utility.stringToDate(dateString: resources["created_date"].stringValue))
                        
                        res.id = resources["id"].intValue
                        res.status = resources["status"].stringValue
                        res.imageUrl = resources["image_url"].stringValue
                        res.name = resources["name"].stringValue
                        res.descriptionText = resources["description"].stringValue
                        
                        transaction.resource  = res

                        
                        
                        let sell = transactions["seller"]
                        
                        let seller =  Seller()
                        seller.last_name =  sell["last_name"].stringValue
                         seller.first_name =  sell["first_name"].stringValue
                        transaction.seller = seller
                        
                        
                        transaction.status = transactions["status"].stringValue
                        transaction.is_buyer = transactions["is_buyer"].boolValue
                        
                        TransactionDao.add(transaction)
                    }
                    
//                    print (jsonData)
                    print(jsonData.count)
                }
            }
            DispatchQueue.main.async {
                onCompletion(statusCode, message)
            }
        })
    }
    
    static func accept(transaction_id: Int, onCompletion: @escaping(Int?, String?) -> Void){
        var message = ""
        TransactionRemote.accept(transaction_id : transaction_id , onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                
                
                
                message = jsonData["message"].stringValue
                
            }
            
            DispatchQueue.main.async {
                onCompletion(statusCode, message)
            }
        })
        
    }
    
    
    static func reject(transaction_id: Int, onCompletion: @escaping(Int?, String?) -> Void){
        var message = ""
        TransactionRemote.reject(transaction_id : transaction_id , onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                
                
                
                message = jsonData["message"].stringValue
                
            }
            
            DispatchQueue.main.async {
                onCompletion(statusCode, message)
            }
        })
        
    }
    
    static func complete(transaction_id: Int, onCompletion: @escaping(Int?, String?) -> Void){
        var message = ""
        TransactionRemote.complete(transaction_id : transaction_id , onCompletion: { jsonData, statusCode in
            DispatchQueue.global(qos: .background).async {
                
                
                
                message = jsonData["message"].stringValue
                
            }
            
            DispatchQueue.main.async {
                onCompletion(statusCode, message)
            }
        })
        
    }

    
    
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
                        for (_, subcategory):(String, JSON) in category["subcategories"] {
                            let newSubcategory = Subcategory()
                            newSubcategory.id = subcategory["id"].intValue
                            newSubcategory.name = subcategory["name"].stringValue
                            newSubcategory.descriptionText = subcategory["description"].stringValue
                            newSubcategory.imageUrl = subcategory["image_url"].stringValue
                            newSubcategory.status = subcategory["status"].stringValue
                            newSubcategory.isSelected = false
                            newSubcategory.parentCategory = newCategory
                            newCategory.subcategories.append(newSubcategory)
                        }
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
        return CategoryDao.getCategories()
    }
    
    static func selectCategory(_ category: Category) {
        CategoryDao.edit(category, keys: ["isSelected"], values: [true])
    }
    
    static func clearSelectedCategories(_ categories: Results<Category>) {
        for category in categories {
            CategoryDao.edit(category, keys: ["isSelected"], values: [false])
        }
    }
    
    static func getSubcategoriesBy(categoryId: Int) -> Results<Subcategory> {
        let subcategories = SubcategoryDao.getSubcategoriesBy(categoryId: categoryId)
        return subcategories
    }
    
    static func selectSubategory(_ subcategory: Subcategory) {
        SubcategoryDao.edit(subcategory, keys: ["isSelected"], values: [true])
    }
    
    static func clearSelectedSubcategories(_ subcategories: Results<Subcategory>) {
        for subcategory in subcategories {
            SubcategoryDao.edit(subcategory, keys: ["isSelected"], values: [false])
        }
    }
}
