//
//  CategoryCollectionViewCell.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

var cornerRadius: CGFloat = 2

var shadowOffsetWidth: Int = 0
var shadowOffsetHeight: Int = 3
var shadowColor: UIColor? = UIColor.black
var shadowOpacity: Float = 0.5

class TransactionTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    
    @IBOutlet weak var orderRefNumberUILabel: UILabel!
    
    @IBOutlet weak var startDateUILabel: UILabel!
    
    @IBOutlet weak var endDateUILabel: UILabel!
    
    @IBOutlet weak var resourceUIImageView: UIImageView!
    
    @IBOutlet weak var resourceNameUILabel: UILabel!
    
    @IBOutlet weak var resourceDescriptionUILabel: UILabel!
    
    @IBOutlet weak var statusUIButton: UIButton!

    @IBOutlet weak var acceptUIButtonOutlet: UIButton!
    @IBOutlet weak var rejectUIButtonOutlet: UIButton!
    
    

    
}
