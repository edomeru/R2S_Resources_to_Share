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
    
    static func edit(_ Transaction: Transaction, keys: [String], values: [Any?]) {
        let realm = try! Realm()
        for item in 0..<keys.count {
            try! realm.write {
                Transaction.setValue(values[item], forKey: keys[item])
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
        let predicate = NSPredicate(format: "is_buyer = %@ AND status = %@", buyer as CVarArg, status)
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
