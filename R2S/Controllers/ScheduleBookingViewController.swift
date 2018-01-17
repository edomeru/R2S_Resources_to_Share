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

class ScheduleBookingViewController: BaseViewController {

    var scheduleBookingView = ScheduleBookingView()
    var selectedResourceId:Int = 0
    var  startDate: Date?
    var  endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUILayout()
       
    }

    private func  initUILayout(){
    
        self.title = "Schedule Booking"
        self.scheduleBookingView = self.loadFromNibNamed(nibNamed: Constants.xib.ScheduleBookingView) as! ScheduleBookingView
        self.view = self.scheduleBookingView
        
    
        
        self.scheduleBookingView.delegate = self
        self.scheduleBookingView.proposalUIGrowingTextView = GrowingTextView()
        self.scheduleBookingView.proposalUIGrowingTextView.delegate = self
        self.scheduleBookingView.proposalUIGrowingTextView.layer.cornerRadius = 4.0
        self.scheduleBookingView.proposalUIGrowingTextView.maxLength = 200
        self.scheduleBookingView.proposalUIGrowingTextView.maxHeight = 70
        self.scheduleBookingView.proposalUIGrowingTextView.trimWhiteSpaceWhenEndEditing = true
        self.scheduleBookingView.proposalUIGrowingTextView.placeHolder = "Say something..."
        self.scheduleBookingView.proposalUIGrowingTextView.placeHolderColor = UIColor(white: 0.8, alpha: 1.0)
        self.scheduleBookingView.proposalUIGrowingTextView.font = UIFont.systemFont(ofSize: 18)
        self.scheduleBookingView.proposalUIGrowingTextView.translatesAutoresizingMaskIntoConstraints = false
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
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                let gregorian = Calendar(identifier: .gregorian)
                                
                                var piStartcComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dt)
                                piStartcComponents.hour = 23
                                piStartcComponents.minute = 59
                                piStartcComponents.second = 59
                                
                                self.endDate = gregorian.date(from: piStartcComponents)!
                                formatter.dateFormat = "dd/MM/YY"
                                
                                self.scheduleBookingView.toUTTextField.text = formatter.string(from: self.endDate!)
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
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                let gregorian = Calendar(identifier: .gregorian)
                                
                                var piStartcComponents = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dt)
                                piStartcComponents.hour = 0
                                piStartcComponents.minute = 0
                                piStartcComponents.second = 0
                                
                                self.startDate = gregorian.date(from: piStartcComponents)!
                                
                                formatter.dateFormat = "dd/MM/YY"
                                self.scheduleBookingView.fromUTTextField.text = formatter.string(from: self.startDate!)
                                print("DATE OUTPUT",self.scheduleBookingView.fromUTTextField.text)
                                
                            }
        }

    }

}


// MARK: - LoginViewDelegate
extension ScheduleBookingViewController: ScheduleBookingViewDelegate {
    func submitOnPressed(sender: AnyObject) {
//        self.loginView.endEditing(true)
//        self.validator.validate(self)
        print("TEST")
    }
    
   
}

extension ScheduleBookingViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

