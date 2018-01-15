//
//  HomeView.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import CZPicker

protocol AccountViewDelegate: class {
    func signoutButtonPressed(sender: AnyObject)
    func settingsButtonPressed(sender: AnyObject)
    
   
}

class AccountView: BaseUIView {
    weak var delegate: AccountViewDelegate?
    @IBOutlet weak var companyUILabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var userNameUILabel: UILabel!
   
    @IBOutlet weak var phoneUILabel: UILabel!
    
   
    @IBAction func signoutUIButton(_ sender: Any) {
        
        delegate?.signoutButtonPressed(sender: sender as AnyObject)
        
    }
    
    @IBOutlet weak var dateJoinedUILabel: UILabel!
    
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var emailUILabel: UILabel!
    @IBAction func settingsUIButtonClick(_ sender: Any) {
        
        delegate?.settingsButtonPressed(sender: sender as AnyObject)
    }
    
}


