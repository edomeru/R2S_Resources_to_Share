//
//  ResourceViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 18/10/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import Foundation
import UIKit

class ResourceViewController: BaseViewController {
    
    var resourceView = ResourceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUILayout()
        
        self.fillUiWithData()
        
    }
    
    
    private func initUILayout() {
        self.resourceView = self.loadFromNibNamed(nibNamed: Constants.xib.resourceView) as! ResourceView
        self.view = self.resourceView
         
        self.resourceView.delegate = self
    }
    
    private func fillUiWithData(){
        
        self.resourceView.categoryLabel.text  = "dadadad"
        
        ResourceService.get{ (statusCode, message) in
            if statusCode == 200 {
            print("PAKYU ENZO!!!!", statusCode!)
            
            }
        }

    }

}

extension ResourceViewController: ResourceViewDelegate {


}

