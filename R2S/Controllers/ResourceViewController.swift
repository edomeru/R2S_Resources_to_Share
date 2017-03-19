//
//  ResourceViewController.swift
//  R2S
//
//  Created by Earth Maniebo on 17/3/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit

class ResourceViewController: BaseViewController {
    
    var resourceView = ResourceView()
    var selectedCategoryId: Int!
    var selectedCategoryName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Functions
    private func initUILayout() {
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.view = self.resourceView
        self.title = selectedCategoryName
    }
}
