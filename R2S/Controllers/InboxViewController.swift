//
//  InboxViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift

class InboxViewController: UIViewController {
    var inbox: Results<Inbox>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchData()
        
        
        
    }
    
    
    private func fetchData(){
        InboxService.getAll(id: UserHelper.getId()! , onCompletion: { statusCode, message in
            
            print("\(statusCode!)" + " INBOX CODE"  )
          
            if statusCode == 200 {
                self.inbox = InboxDao.getAll()
                  print("\(self.inbox)" + " INBOX MSG"  )
                
                //self.initUILayout()
            }
        })
        
    }
    
    
}
