//
//  TransactionDao.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionDao {
    static func getTransactions() -> Results<Transaction> {
        let realm = try! Realm()
        let transactions = realm.objects(Transaction.self)
        return transactions
    }
    
    static func getOneBy(transactionId: Int) -> Transaction? {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", transactionId)
        let transaction = realm.objects(Transaction.self).filter(predicate).first
        return transaction
    }
    
    static func add(_ Transaction: Transaction) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(Transaction, update: true)
        }
    }
    
    
    
    //    static func edit(_ transactionId: Int, Transaction: Results<Transaction>, keys: [String], values: [Any?]) {
    //        let realm = try! Realm()
    //        for item in 0..<keys.count {
    //            try! realm.write {
    //                 let predicate = NSPredicate(format: "id = %d", transactionId)
    //                Transaction.setValue(values[item], forKey: keys[item])
    //            }
    //        }
    //    }
    
    
    static func update(status: String, transaction_id: Int){
        let realm = try! Realm()
        try! realm.write {
            for person in realm.objects(Transaction.self).filter("id == %d", transaction_id) {
                person.status = status
            }
        }
        
    }
    static func delete(_ Transaction: Transaction) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(Transaction)
        }
    }
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            let transactions = realm.objects(Transaction.self)
            realm.delete(transactions)
        }
    }
    
    static func getAllBuyers(buyer: Bool, status: String) -> Results<Transaction> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "(is_buyer = %@ AND status = %@) OR (is_buyer = %@ AND status = %@)", buyer as CVarArg, status,buyer as CVarArg, "ACCEPTED")
        let buyer = realm.objects(Transaction.self).filter(predicate)
        return buyer
    }
    
    static func getCompletedTransactions() -> Results<Transaction> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "status = %@ OR status = %@ OR status = %@", "COMPLETED", "CANCELLED", "REJECTED")
        let buyer = realm.objects(Transaction.self).filter(predicate)
        return buyer
    }
    
    
}
