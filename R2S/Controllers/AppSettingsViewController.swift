//
//  AppSettingsViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

class AppSettingsViewController: BaseViewController {

    
    var appSettingsView = AppSettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUILayout()
        self.title = "Settings"
        
    }

    private func initUILayout() {
        
        self.appSettingsView = self.loadFromNibNamed(nibNamed: Constants.xib.AppSettingsView) as! AppSettingsView
        self.appSettingsView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.appSettingsView)
        
    }

}
