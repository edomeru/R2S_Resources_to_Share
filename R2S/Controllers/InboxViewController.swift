//
//  InboxViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 5/12/17.
//  Copyright © 2017 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift


class InboxViewController: BaseViewController {
    var inbox: Results<Inbox>!
    var inboxView = InboxView()
    var selectedChatId:Int?
    var selectedResourceId:Int?
    var resourceName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchData()
        
        
        
    }
    
    
    private func fetchData(){
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        InboxService.getAll(id: UserHelper.getId()! , onCompletion: { statusCode, message in
            
           // print("\(statusCode!)" + " INBOX CODE"  )
          
            if statusCode == 200 {
                self.inbox = InboxDao.getAll()
                 // print("\(self.inbox!)" + " INBOX MSG"  )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                
                self.initUILayout()
                    
                     })
            }
        })
        
    }
    
    
    private func initUILayout() {
        
        
        self.inboxView = self.loadFromNibNamed(nibNamed: Constants.xib.inboxView) as! InboxView
        self.view = self.inboxView
        

        
        self.inboxView.inboxTableView.register(UINib(nibName: Constants.xib.inboxTableViewCell, bundle:nil), forCellReuseIdentifier: "InboxTableViewCell")
        self.inboxView.inboxTableView.delegate = self
        self.inboxView.inboxTableView.dataSource = self 
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.segue.InboxToChatSegue:
                let destinationVC = segue.destination as! ChatViewController
                destinationVC.selectedChatId = selectedChatId
                destinationVC.selectedResourceId = selectedResourceId
                 destinationVC.resourceName  =  resourceName
            default:
                print("default");
            }
        }
    }
    
    
}



// MARK: - UITableViewDelegate
extension InboxViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
// MARK: - UITableViewDelegate
extension InboxViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.inboxView.inboxTableView {
            return self.inbox.count
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath) as! InboxTableViewCell
        
        
        cell.name_UILabel.text =  inbox[indexPath.row].last_message?.account_name
        
        
        cell.lastmsg_UILabel.text = inbox[indexPath.row].last_message?.message
        
        if  self.inbox[indexPath.item].participants.first?.account_image_url  != "" {
            cell.inbox_imageUIImageView.contentMode = .scaleAspectFill
            cell.inbox_imageUIImageView.layer.cornerRadius = 25.958897898
            cell.inbox_imageUIImageView.clipsToBounds = true
            cell.inbox_imageUIImageView.kf.setImage(with: URL(string: (inbox[indexPath.item].last_message?.account_image_url)!), options: [.transition(.fade(0.2))])
            
            
        }else{
            
            
            let url = URL(string: "http://theblackpanthers.com/s/photogallery/img/no-image-available.jpg")
            cell.inbox_imageUIImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inboxChat = inbox[indexPath.item]
        selectedChatId  = inboxChat.id
        selectedResourceId  = inboxChat.resource?.id
        resourceName = inbox[indexPath.item].resource?.name
         print (selectedChatId)
        performSegue(withIdentifier: Constants.segue.InboxToChatSegue, sender: self)
    }
}
