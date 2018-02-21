//
//  SearchView.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 29/1/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewDelegate: class {
    func sortButtonPressed(sender: AnyObject)
    func moreFilterButtonPressed(sender: AnyObject)
}

internal class SearchView : BaseUIView {
    weak var delegate: SearchViewDelegate?
 
    @IBOutlet weak var noResourcesFoundUILabel: UILabel!
    
    @IBAction func moreFiltersUIButton(_ sender: AnyObject) {
        delegate?.moreFilterButtonPressed(sender: sender)
    }
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBAction func sortUIButton(_ sender: AnyObject) {
         delegate?.sortButtonPressed(sender: sender)
    }
   
    
}
