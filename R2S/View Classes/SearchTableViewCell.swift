//
//  SearchTableViewCell.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 30/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var imageUIImageView: UIImageView!
    
    @IBOutlet weak var dateUILabel: UILabel!
  
    @IBOutlet weak var titleUILabel: UILabel!
    
    @IBOutlet weak var infoUILabel: UILabel!
    
    @IBOutlet weak var priceUILabel: UILabel!
    
    @IBOutlet weak var favIconUIImageView: UIImageView!

}
