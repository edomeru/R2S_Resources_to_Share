//
//  ProfileHeaderViewCell.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 2/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

class ProfileHeaderViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    @IBOutlet weak var profileHeaderPIcUImageView: UIImageView!

    @IBOutlet weak var usernameHeaderUILabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var profileHeaderNameUImageView: UILabel!
    
    @IBOutlet weak var companyHeaderUILabel: UILabel!
    
    @IBOutlet weak var emailHeaderUILabel: UILabel!

    @IBOutlet weak var phoneNumberHeaderUILabel: UILabel!
    
    @IBOutlet weak var settingsHeaderUIButton: UIButton!
    
    @IBOutlet weak var signOutHeaderUIButton: UIButton!
    
    
}
