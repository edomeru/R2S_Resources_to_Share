//
//  ResourceView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 18/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import UIKit

protocol ResourceViewDelegate: class {
    
}

class ResourceView: BaseUIView {
 weak var delegate: ResourceViewDelegate?
    
    
    @IBOutlet weak var resourceImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var titleSubLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}
