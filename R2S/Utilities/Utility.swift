//
//  Utility.swift
//  R2S
//
//  Created by Earth Maniebo on 15/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import Alamofire

class Utility {
    class func showAlert(title: String, message: String, targetController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.view.tintColor = UIColor(hex: Constants.color.primary)
        targetController.present(alert, animated: true, completion: nil)
    }
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    class func getHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        return headers
    }
    
    class func getHeadersWithAuth() -> HTTPHeaders {
        let username = UserHelper.getEmail()!
        let password = UserHelper.getPassword()!
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        var headersWithAuth = getHeaders()
        headersWithAuth["Authorization"] = "Basic \(base64LoginString)"
        return headersWithAuth
    }
    
    class func stringToDate(dateString: String?) -> Date {
        if dateString != ""{
            let dateFormatter = DateFormatter()
            // dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
            dateFormatter.dateFormat = "dd/M/yyyy, H:mm a"
            let date = dateFormatter.date(from: dateString!)
            
            
            /////TEST
            
            let calendar = NSCalendar.current
            if let dateTriggered = date {
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateTriggered)
                let finalDate = calendar.date(from:components)
                
                print("INSIDE DATE FUNCTION",finalDate!)
                return date!
            }
            return Date()
        }
        return Date()
    }
    
    class func dateToString(dateString: Date?) -> String {
        if dateString != nil{
            let dateFormatter = DateFormatter()
            // dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
            
            dateFormatter.dateFormat = "dd/M/yyyy, H:mm a"
            let stringDate = dateFormatter.string(from: dateString!)
            
            return stringDate
        }
        return String()
    }
}
