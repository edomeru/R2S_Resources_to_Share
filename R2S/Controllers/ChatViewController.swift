//
//  ChatViewController.swift
//  R2S
//
//  Created by Innoverde Pte Ltd on 6/2/18.
//  Copyright © 2018 Total Integrated Resources. All rights reserved.
//

import UIKit
import RealmSwift


class ChatViewController: BaseViewController, UITextFieldDelegate {
    var chatView = ChatView()
    var selectedChatId:Int?
    var selectedResourceId:Int?
    var conversation: Results<Conversation>!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var params = [String: Any]()
    var resourceName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.chatView.sendUITextfield.text != "" {
        sendMessage()
        }
        
        return true
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
        print("CHAT_ID",selectedChatId!)
        ConversationService.getMessages(messageId: selectedChatId! , onCompletion: { statusCode, message in
            
            
            if statusCode == 200 {
                
                ConversationDao.deleteAll()
                self.conversation = ConversationDao.getAll()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    activityIndicator.stopAnimating()
                    self.title = self.resourceName
                    self.initUILayout()
                    
                })
            }
        })
        
    }
    
    
    
    private func initUILayout() {
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        self.chatView = self.loadFromNibNamed(nibNamed: Constants.xib.ChatView) as! ChatView
        self.chatView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view = self.chatView
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.chatView.chatUICollectionView.register(UINib(nibName: Constants.xib.chatCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: "chatCollectionViewCell")
        
        self.chatView.chatUICollectionView.delegate = self
        self.chatView.chatUICollectionView.dataSource = self
        self.chatView.sendUITextfield.delegate = self
        self.chatView.sendUITextfield.becomeFirstResponder()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.chatView.sendUIImageView.isUserInteractionEnabled = true
        self.chatView.sendUIImageView.addGestureRecognizer(tapGestureRecognizer)
        self.chatView.chatUICollectionView.reloadData()
        let item = self.collectionView(self.chatView.chatUICollectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.chatView.chatUICollectionView.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
        
        
        print("CONVERSATIONCOUNT",self.conversation)
        
    }
    
    func dismissKeyboard() {
      
        view.endEditing(true)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if self.chatView.sendUITextfield.text != "" {
        sendMessage()
        }
        
    }
    
    
    func sendMessage() {
    
    let message = self.chatView.sendUITextfield.text
        print(message!)
        
        params["resource_id"] = selectedResourceId
        params["message"] = message!
        let messageparam = MessageParam()
        messageparam.resourceId = selectedResourceId!
        messageparam.message = message!
        print("PARAM", params)
        
        ConversationService.sendMessage(conversation_id: selectedChatId!,params: params, onCompletion: { statusCode, message in
            print("\(statusCode!)" + " CHATSTATUS"  )
            print("\(message!)" + " CHATKSON"  )
           
            if statusCode == 202 {
                 self.chatView.sendUITextfield.text = ""
                //Utility.showSnackBAr(messege:"Booked Successfully", bgcolor: UIColor(hexString: Constants.color.greenSnackBar)!)
                let currentDate = Date()
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                let singaporeFormat2 =  dateFormatter2.string(from: currentDate)
                print("CURRENT_DATE", singaporeFormat2)
                
                
                let convo = Conversation()
                convo.message = message!
                convo.id = self.selectedChatId! + 1
                convo.convo_id = self.selectedChatId! + 1
                convo.account_name = UserHelper.getfullName()!
                convo.account_image_url = UserHelper.getImageUrl()!
                convo.date_created = singaporeFormat2
                convo.is_read = false
                convo.author_id = UserHelper.getId()!
                ConversationDao.add(convo)
                
                self.fetchData()
                
                
            } else if statusCode != 202 {
                Utility.showAlert(title: "Error " + "\(statusCode!)" , message: message!, targetController: self)
                
            }
            
        })
        
        
    }
    
}





// MARK: UICollectionViewDelegate
extension ChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       self.chatView.sendUITextfield.endEditing(true)
    }
    
    
    
}


// MARK: - UICollectionViewDataSource
extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(30, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if case let messageText = conversation[indexPath.item].message {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: CGSize(width: view.frame.width, height: 1000),
                                                                                    options: options,
                                                                                    attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)],
                                                                                    context: nil).size
            return CGSize(width: view.frame.width, height: estimatedFrame.height)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if collectionView == self.chatView.chatUICollectionView {
        return self.conversation.count
        //}
        //return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.chatView.chatUICollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.xib.chatCollectionViewCell, for: indexPath) as! chatCollectionViewCell
            
            //            if  collectionViewCount == false {
            //                collectionViewCount = true
            //                cell.subcategoryLabel.text = "ALL"
            //
            //                if self.subcategories[indexPath.item].isSelected {
            //                    cell.categoryUnderlineView.backgroundColor = UIColor(hex: Constants.color.primary)
            //                } else {
            //                    cell.categoryUnderlineView.backgroundColor = UIColor.clear
            //                }
            //
            //            }else{
            //            cell.preservesSuperviewLayoutMargins = false
            //
            //            cell.layoutMargins = UIEdgeInsets.zero
            
            
            cell.bubbleUIView.clipsToBounds = true
            cell.message.text = self.conversation[indexPath.item].message
            
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" //Your date format
            dateFormatter1.timeZone = TimeZone(abbreviation: "GMT+4:00") //Current time zone
            let date1 = dateFormatter1.date(from: self.conversation[indexPath.item].date_created) //according to date format your date string
            print("date",date1)
            
            dateFormatter1.dateFormat = "MMM d, yyyy, hh:mm a"
            let singaporeFormat1 =  dateFormatter1.string(from: date1!)
            
            
            cell.dateUILabel.text = singaporeFormat1
            
            if  self.conversation[indexPath.item].account_image_url  != "" {
                cell.imageUICollectionView.contentMode = .scaleAspectFill
                cell.imageUICollectionView.layer.cornerRadius = 16.958897898
                cell.imageUICollectionView.clipsToBounds = true
                cell.imageUICollectionView.kf.setImage(with: URL(string: (conversation[indexPath.item].account_image_url)), options: [.transition(.fade(0.2))])
               
                
            }
            
            if case let messageText = conversation[indexPath.item].message {
                let size = CGSize(width: 250, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: messageText).boundingRect(with: CGSize(width: view.frame.width, height: 1000),
                                                                                options: options,
                                                                                attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)],
                                                                                context: nil).size
               
                
                if self.conversation[indexPath.item].account_name == UserHelper.getfullName() {
                    cell.bubbleUIView.backgroundColor = UIColor(hexString: Constants.color.electricBlue)
                    cell.bubbleUIView.layer.cornerRadius = 15
                    cell.message.textColor = UIColor(hexString: Constants.color.white)
                    cell.message.frame = CGRect(origin: CGPoint(x:8 ,y:2), size: CGSize(width: estimatedFrame.width , height: estimatedFrame.height))
                    cell.bubbleUIView.frame = CGRect(origin: CGPoint(x:view.frame.width - estimatedFrame.width - 8 ,y:16), size: CGSize(width: estimatedFrame.width, height: estimatedFrame.height + 8))
                    cell.dateUILabel.frame = CGRect(origin: CGPoint(x:cell.frame.width / 3 ,y:  1), size: CGSize(width: estimatedFrame.width + 40, height: 10))
                    
                    cell.imageUICollectionView.isHidden = true
                    
                } else {
                    //Outgoing sending message
                    
                    cell.bubbleUIView.backgroundColor = UIColor(hexString: Constants.color.athensGray)
                    cell.bubbleUIView.layer.cornerRadius = 15
                    cell.message.frame = CGRect(origin: CGPoint(x:8,y:2), size: CGSize(width: estimatedFrame.width , height: estimatedFrame.height))
                    cell.bubbleUIView.frame = CGRect(origin: CGPoint(x:48,y:16), size: CGSize(width: estimatedFrame.width, height: estimatedFrame.height + 6))
                    cell.imageUICollectionView.frame = CGRect(origin: CGPoint(x:8,y:estimatedFrame.height - 10), size: CGSize(width: 31, height: 31))
                    
                    cell.dateUILabel.frame = CGRect(origin: CGPoint(x:cell.frame.width / 3 ,y:  1), size: CGSize(width: estimatedFrame.width + 40, height: 10))
                    
                    cell.imageUICollectionView.isHidden = false
                    
                }
                
                
                
            }
            //
            //            if self.subcategories[indexPath.item].isSelected {
            //                cell.categoryUnderlineView.backgroundColor = UIColor(hex: Constants.color.primary)
            //            } else {
            //                cell.categoryUnderlineView.backgroundColor = UIColor.clear
            //            }
            //
            
            
            
            //}
            
            
            
            return cell
        }
        return UICollectionViewCell()
    }
}


