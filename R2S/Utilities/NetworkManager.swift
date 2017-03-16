//
//  NetworkManager.swift
//  R2S
//
//  Created by Earth Maniebo on 14/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedInstance = NetworkManager()
    private var manager : SessionManager?
    
    func SessionManager() -> SessionManager {
        if let m = self.manager{
            return m
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = 60 // seconds
            configuration.timeoutIntervalForRequest = 60 // seconds
            
            let tempManager = Alamofire.SessionManager(configuration: configuration)
            self.manager = tempManager
            return self.manager!
        }
    }
}
