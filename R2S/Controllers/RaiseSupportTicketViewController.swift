//
//  RaiseSupportTicketViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

class RaiseSupportTicketViewController: BaseViewController {

    var raiseSupportTicketView = RaiseSupportTicketView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUILayout()
        self.title = "Raise Support Ticket"
    }

    private func initUILayout() {
        
        self.raiseSupportTicketView = self.loadFromNibNamed(nibNamed: Constants.xib.RaiseSupportTicketView) as! RaiseSupportTicketView
        self.raiseSupportTicketView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.raiseSupportTicketView)
        
    }
}
