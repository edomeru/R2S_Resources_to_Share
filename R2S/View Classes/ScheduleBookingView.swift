//
//  ScheduleBookingView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 17/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//
import UIKit
import GrowingTextView

protocol ScheduleBookingViewDelegate: class {
    func submitOnPressed(sender: AnyObject)
    
}

class ScheduleBookingView: BaseUIView {
weak var delegate: ScheduleBookingViewDelegate?

    
    @IBOutlet weak var proposalUIGrowingTextView: GrowingTextView!

    @IBOutlet weak var fromUTTextField: UITextField!

    @IBOutlet weak var toUTTextField: UITextField!
    @IBOutlet weak var quantityUTTextField: UITextField!

    @IBAction func submitOnPressed(_ sender: Any) {
        delegate?.submitOnPressed(sender: AnyObject.self as AnyObject)
    }
}
