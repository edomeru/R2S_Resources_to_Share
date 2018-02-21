//
//  ScheduleBookingViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 17/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import GrowingTextView
import DatePickerDialog
import SwiftSpinner

class ScheduleBookingViewController: BaseViewController,UITextViewDelegate {
    
    var scheduleBookingView = ScheduleBookingView()
    var selectedResourceId:Int = 1
    var  startDate: Date?
    var  endDate: Date?
    var params = [String: Any]()
    var startDateString: String?
    var endDateString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUILayout()
        
        
    }
    
    private func  initUILayout(){
        
        self.title = "Schedule Booking"
        self.scheduleBookingView = self.loadFromNibNamed(nibNamed: Constants.xib.ScheduleBookingView) as! ScheduleBookingView
        self.view = self.scheduleBookingView
        
        automaticallyAdjustsScrollViewInsets = false
        
        self.scheduleBookingView.delegate = self
        
        self.scheduleBookingView.proposalUITextView.placeholder = "A message will be sent to the seller..."
        self.scheduleBookingView.fromUTTextField.addTarget(self, action: Selector("datePickerFromTapped"), for: UIControlEvents.editingDidBegin)
        self.scheduleBookingView.toUTTextField.addTarget(self, action: Selector("datePickerEndTapped"), for: UIControlEvents.editingDidBegin)
        
        
    }
    
    func datePickerEndTapped() {
        let currentDate = Date()
        
        
        let datePicker = DatePickerDialog(textColor: UIColor(hexString: Constants.color.primary)!,
                                          buttonColor: UIColor(hexString: Constants.color.primaryDark)!,
                                          font: UIFont.boldSystemFont(ofSize: 15),
                                          showCancelButton: true)
        datePicker.show("End Date",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: currentDate)!),
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                let singaporeFormatter = DateFormatter()
                                let gregorian = Calendar(identifier: .gregorian)
                                
                                var piStartcComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dt)
                                piStartcComponents.hour = 23
                                piStartcComponents.minute = 59
                                piStartcComponents.second = 59
                                
                                self.endDate = gregorian.date(from: piStartcComponents)!
                                formatter.dateFormat = "dd/MM/YY"
                                singaporeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                self.scheduleBookingView.toUTTextField.text = formatter.string(from: self.endDate!)
                                self.endDateString = singaporeFormatter.string(from: self.endDate!)
                                print("DATE END OUTPUT",self.scheduleBookingView.toUTTextField.text )
                            }
        }
        
        
        
    }
    
    func datePickerFromTapped() {
        let currentDate = Date()
        
        
        let datePicker = DatePickerDialog(textColor: UIColor(hexString: Constants.color.primary)!,
                                          buttonColor: UIColor(hexString: Constants.color.primaryDark)!,
                                          font: UIFont.boldSystemFont(ofSize: 15),
                                          showCancelButton: true)
        datePicker.show("Start Date",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: currentDate)!),
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                let singaporeFormatter = DateFormatter()
                                let gregorian = Calendar(identifier: .gregorian)
                                
                                var piStartcComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dt)
                                piStartcComponents.hour = 0
                                piStartcComponents.minute = 0
                                piStartcComponents.second = 0
                                
                                self.startDate = gregorian.date(from: piStartcComponents)!
                                
                                formatter.dateFormat = "dd/MM/YY"
                                singaporeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                self.scheduleBookingView.fromUTTextField.text = formatter.string(from: self.startDate!)
                                self.startDateString = singaporeFormatter.string(from: self.startDate!)
                                print("DATE OUTPUT",self.scheduleBookingView.fromUTTextField.text)
                                print("STARTDATEE",self.startDate )
                            }
        }
        
    }
    
}


// MARK: - LoginViewDelegate
extension ScheduleBookingViewController: ScheduleBookingViewDelegate {
    func submitOnPressed(sender: AnyObject) {
        //        self.loginView.endEditing(true)
        //        self.validator.validate(self)
        print(selectedResourceId)
        // print("KJDADKAD",self.scheduleBookingView.proposalUIGrowingTextView.textStorage)
        //print(self.scheduleBookingView.proposalUIGrowingTextView.text.capitalized)
        print(self.scheduleBookingView.quantityUTTextField.text )
        params["resource_id"] = selectedResourceId as AnyObject
        params["proposal"] = self.scheduleBookingView.proposalUITextView.text
        params["quantity"] = self.scheduleBookingView.quantityUTTextField.text as AnyObject
        params["booking_start_date"] = self.startDateString
        params["booking_end_date"] = self.endDateString
        
        print("params",params)
         SwiftSpinner.show("Please wait...")
        UserService.createTransaction(params  , onCompletion: { statusCode, message in
            print("\(statusCode!)" + " ScheduleBookingViewController"  )
            print("\(message!)" + " ScheduleBookingViewController"  )
            SwiftSpinner.hide()
            if statusCode == 201 {
                self.navigationController?.popViewController(animated: true)
                Utility.showSnackBAr(messege:"Booked Successfully", bgcolor: UIColor(hexString: Constants.color.greenSnackBar)!)
                
            } else if statusCode == 400 {
                Utility.showAlert(title: "Error " + "\(statusCode!)" , message: message!, targetController: self)
                
            }
            
        })
        
    }
}


