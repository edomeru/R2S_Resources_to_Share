//
//  HomeView.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit


protocol ActivityViewDelegate: class {
    func segmentedViewOnPressed(sender: AnyObject)
    
}

class ActivityView: BaseUIView {
     weak var delegate: ActivityViewDelegate?
    @IBAction func activitySegmentedControl(_ sender: Any) {
        delegate?.segmentedViewOnPressed(sender: sender as AnyObject)
    }
    
    @IBOutlet weak var activityTableView: UITableView!

    override func awakeFromNib() {
        activityTableView.backgroundColor = UIColor.init(hex: Constants.color.athensGray)
    }
}
