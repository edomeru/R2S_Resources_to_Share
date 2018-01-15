//
//  EditProfileViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 9/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import Foundation

class EditProfileViewController: BaseViewController {

    
    var editProfileView = EditProfileView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initUILayout()
        self.title = "Edit Profile"

        // Do any additional setup after loading the view.
    }
    private func initUILayout() {
    
        self.editProfileView = self.loadFromNibNamed(nibNamed: Constants.xib.EditProfile) as! EditProfileView
        self.editProfileView.frame = CGRect(x: 0, y: Constants.navbarHeight, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(self.editProfileView)
    
    }
    
}
