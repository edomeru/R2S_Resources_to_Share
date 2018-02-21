//
//  HomeView.swift
//  R2S
//
//  Created by Earth Maniebo on 16/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

protocol WishlistViewDelegate: class {
    func segmentedViewOnPressed(sender: AnyObject)
   
}

class WishlistView: BaseUIView {
    weak var delegate: WishlistViewDelegate?
    @IBOutlet weak var WishListTableView: UITableView!
    @IBAction func SegmentedUIView(_ sender: Any) {
        delegate?.segmentedViewOnPressed(sender: sender as AnyObject)
        
    }
    
    
    
    
}
