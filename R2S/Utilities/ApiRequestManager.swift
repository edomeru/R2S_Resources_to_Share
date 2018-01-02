//
//  ApiRequestManager.swift
//  R2S
//
//  Created by Earth Maniebo on 14/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias ServiceResponse = (JSON, Int?) -> Void

class ApiRequestManager {
    static let sharedInstance = ApiRequestManager()
    
    func doGetRequest(urlString: String,
                      headers: HTTPHeaders,
                      onCompletion: @escaping ServiceResponse) {
        NetworkManager.sharedInstance.SessionManager().request(urlString,
                                                               method: .get,
                                                               headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    let responseBody = String(data: response.result.value!, encoding: .utf8)
                    var jsonData = JSON.init(parseJSON: responseBody!)
                    
                    if responseBody == nil {
                        let tempJsonData: JSON = ["message": ""]
                        jsonData = tempJsonData
                    } else if jsonData == JSON.null && responseBody != nil {
                        let tempJsonData: JSON = ["message": responseBody!]
                        jsonData = tempJsonData
                    }
                    
                    onCompletion(jsonData, statusCode)
                case .failure:
                    onCompletion(JSON(["message": "Network connection failed."]), 1000)
                }
        }
    }
    
    func doPostRequest(urlString: String,
                       params: [String: Any],
                       headers: HTTPHeaders,
                       onCompletion: @escaping ServiceResponse) {
        NetworkManager.sharedInstance.SessionManager().request(urlString,
                                                               method: .post,
                                                               parameters: params,
                                                               encoding: JSONEncoding.default,
                                                               headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    let responseBody = String(data: response.result.value!, encoding: .utf8)
                    var jsonData = JSON.init(parseJSON: responseBody!)
                    
                    if responseBody == nil {
                        let tempJsonData: JSON = ["message": ""]
                        jsonData = tempJsonData
                    } else if jsonData == JSON.null && responseBody != nil {
                        let tempJsonData: JSON = ["message": responseBody!]
                        jsonData = tempJsonData
                    }
                    onCompletion(jsonData, statusCode)
                case .failure:
                    onCompletion(JSON(["message": "Network connection failed."]), 1000)
                }
        }
    }
    
    
    func doPostRequestNoAuth(urlString: String,
                             params: [String: AnyObject],
                             headers: HTTPHeaders,
                             onCompletion: @escaping ServiceResponse) {
        NetworkManager.sharedInstance.SessionManager().request(urlString,
                                                               method: .post,
                                                               parameters: params,
                                                               encoding: JSONEncoding.default,
                                                               headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    let responseBody = String(data: response.result.value!, encoding: .utf8)
                    var jsonData = JSON.init(parseJSON: responseBody!)
                    
                    if responseBody == nil {
                        let tempJsonData: JSON = ["message": ""]
                        jsonData = tempJsonData
                    } else if jsonData == JSON.null && responseBody != nil {
                        let tempJsonData: JSON = ["message": responseBody!]
                        jsonData = tempJsonData
                    }
                    onCompletion(jsonData, statusCode)
                case .failure:
                    onCompletion(JSON(["message": "Network connection failed."]), 1000)
                }
        }
    }
    
    func doPutRequest(urlString: String,
                      params: [String: AnyObject],
                      headers: HTTPHeaders,
                      onCompletion: @escaping ServiceResponse) {
        NetworkManager.sharedInstance.SessionManager().request(urlString,
                                                               method: .put,
                                                               parameters: params,
                                                               encoding: JSONEncoding.default,
                                                               headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    let responseBody = String(data: response.result.value!, encoding: .utf8)
                    var jsonData = JSON.init(parseJSON: responseBody!)

                    
                    if responseBody == nil {
                        let tempJsonData: JSON = ["message": ""]
                        jsonData = tempJsonData
                    } else if jsonData == JSON.null && responseBody != nil {
                        let tempJsonData: JSON = ["message": responseBody!]
                        jsonData = tempJsonData
                    }
                    onCompletion(jsonData, statusCode)
                case .failure:
                    onCompletion(JSON(["message": "Network connection failed."]), 1000)
                }
        }
    }
    
    func doDeleteRequest(urlString: String,
                      params: [String: AnyObject],
                      headers: HTTPHeaders,
                      onCompletion: @escaping ServiceResponse) {
        NetworkManager.sharedInstance.SessionManager().request(urlString,
                                                               method: .delete,
                                                               parameters: params,
                                                               encoding: JSONEncoding.default,
                                                               headers: headers)
            .responseData { response in
                switch response.result {
                case .success:
                    let statusCode = response.response?.statusCode
                    let responseBody = String(data: response.result.value!, encoding: .utf8)
                    var jsonData = JSON.init(parseJSON: responseBody!)
                    
                    
                    if responseBody == nil {
                        let tempJsonData: JSON = ["message": ""]
                        jsonData = tempJsonData
                    } else if jsonData == JSON.null && responseBody != nil {
                        let tempJsonData: JSON = ["message": responseBody!]
                        jsonData = tempJsonData
                    }
                    onCompletion(jsonData, statusCode)
                case .failure:
                    onCompletion(JSON(["message": "Network connection failed."]), 1000)
                }
        }
    }
}
