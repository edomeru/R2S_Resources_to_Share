//
//  InboxTableViewCell.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 6/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import UIKit

class InboxTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var inbox_imageUIImageView: UIImageView!
    
    @IBOutlet weak var name_UILabel: UILabel!
    
    @IBOutlet weak var lastmsg_UILabel: UILabel!

}
