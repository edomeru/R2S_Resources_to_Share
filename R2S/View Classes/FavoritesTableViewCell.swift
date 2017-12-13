//
//  FavoritesTableViewCell.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 2/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit


class FavoritesTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
}
    
    @IBOutlet weak var favImage: UIImageView!
    
    @IBOutlet weak var favDateUILabel: UILabel!
    
    @IBOutlet weak var favTitleUILabel: UILabel!
    
    @IBOutlet weak var favoriteIconUIImageView: UIImageView!
    @IBOutlet weak var descriptionTextUILabel: UILabel!

    @IBOutlet weak var priceUILabel: UILabel!
}

