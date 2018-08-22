//
//  ChatViewController.swift
//  TrueDate
//
//  Created by Armenuhi on 1/28/18.
//  Copyright © 2018 Company. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Alamofire
import SwiftyJSON


class ChatViewController: JSQMessagesViewController, UIGestureRecognizerDelegate
 {
    
    var currentUser = UserRequestsService().currentUser
    var messages = [Messages]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var opponentUserId: String!
    let messgaeInfoView = UIView()
    var chatUserInfo = [String]()
    var chatImageUrl = [String]()
    
    var openedFirstTime: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openedFirstTime = false
        
        // Setup navigation
        setupBackButton()
        
        converstaionExists()
       
        // Bubbles with tails
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        
        self.navigationController?.navigationBar.tintColor = UIColor.red

        
        // This is a beta feature that mostly works but to make things more stable it is diabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        self.inputToolbar.contentView?.leftBarButtonItem?.isHidden = true
    }

    override func senderId() -> String {
        // Current user id
        let currentUserId = (currentUser?.id)!
        let updatedId: String = "\(currentUserId)"

        return updatedId
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton) {

    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        let message = Messages(text: text, senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMediaMessage: false, imageUrl: nil)
        self.messages.append(message)
        self.finishSendingMessage()
        
        
        // Current user id
        let currentUserId = (currentUser?.id)!
        let updatedId: String = String(currentUserId)
        
        // Opponenet user id
        opponentUserId = UserDefaults.standard.string(forKey: "opponentUserId")
        
        let baseURL = Constants.GET_USER_CONVERSATIONS
        let path = baseURL + updatedId
        print("Path", path)
        
        // Get Converstions
        Alamofire.request(path).validate().responseJSON { response in
            switch response.result {
            case .success:
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print("swiftyJsonVar", swiftyJsonVar)
                    let dataCount = swiftyJsonVar.arrayValue.count
                    if dataCount == 0 {
                        print("Data count was 0")
                        print("Not contains send post request for creating new conversation")
                        UserDefaults.standard.set("Not contains", forKey: "conversationId")
                    }else {
                        
                        for item in swiftyJsonVar.arrayValue {
                            let otherUserId = item["OtherUser"]["Id"].stringValue
                            if otherUserId == self.opponentUserId! {
                                // Get converstion idconverstion
                                let conversationId = item["ConversationId"].stringValue
                                UserDefaults.standard.set(conversationId, forKey: "conversationId")
                                // If contains not send post request
                                print("Contains NOT send post request")
                                
                                break
                            } else {
                                print("Not contains send post request for creating new conversation")
                                UserDefaults.standard.set("Not contains", forKey: "conversationId")
                            }
                        }
                    }
                    
                    let conversationIdData = UserDefaults.standard.string(forKey: "conversationId")
                    if conversationIdData == "Not contains" {
                        self.messgaeInfoView.isHidden = true
                        // Post
                        let messagePath = Constants.POST_MESSAGES
                        var parameters = [String:Any]()
                        parameters["ConversationId"] = ""
                        parameters["FromUserId"] = self.currentUser?.id
                        parameters["ToUserId"] = self.opponentUserId
                        parameters["Message"] = text
                        
                        let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
                        Alamofire.request(messagePath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            print("POST RESPONSE 1 ")
                        }
                    }else {
                        // Post
                        let messagePath = Constants.POST_MESSAGES
                        var parameters = [String:Any]()
                        parameters["ConversationId"] = conversationIdData
                        parameters["FromUserId"] = self.currentUser?.id
                        parameters["ToUserId"] = self.opponentUserId
                        parameters["Message"] = text
                        
                        let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
                        Alamofire.request(messagePath, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            print("POST RESPONSE 2 ")
                        }
                    }
                } else {
                    print("EMPTY")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 
    
    func getUserPhoto(opponentUserIdInfo: String) {
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + opponentUserIdInfo
        
        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let responseDict = result as! [String : Any]
                    let data = responseDict["PhotoUrl"] as? String
                    let userName = responseDict["FirstName"] as? String
                    if data != "" {
                        self.createHeader(userPhoto: data!, userName: userName!)
                    }else {
                        self.createHeader(userPhoto: "default_photo", userName: userName!)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCenterUiInfo(opponentUserIdInfo: String) {
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + opponentUserIdInfo

        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let responseDict = result as! [String : Any]
                    let data = responseDict["PhotoUrl"] as? String
                    let userName = responseDict["FirstName"] as? String
                    if data != "" {
                        self.createCenter(userPhoto: data!, userName: userName!)
                    }else {
                        self.createCenter(userPhoto: "default_photo", userName: userName!)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
   
    
    
    func converstaionExists() {
        
        // Current user id
        let currentUserId = (currentUser?.id)!
        let updatedId: String = String(currentUserId)
        
        // Opponenet user id
        let opponentUserId = UserDefaults.standard.string(forKey: "opponentUserId")
        
        getUserPhoto(opponentUserIdInfo: opponentUserId!)
        
        let baseURL = Constants.GET_USER_CONVERSATIONS
        let path = baseURL + updatedId
        
        // Get Converstions
        Alamofire.request(path).validate().responseJSON { response in
            switch response.result {
            case .success:
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print("swiftyJsonVar", swiftyJsonVar)
                    let dataCount = swiftyJsonVar.arrayValue.count
                    if dataCount == 0 {
                        print("Data count was 0")
                        print("Not contains send post request for creating new conversation")
                        UserDefaults.standard.set("NotContainsFirst", forKey: "conversationIdFirst")
                    }else {
                        
                        for item in swiftyJsonVar.arrayValue {
                            let otherUserId = item["OtherUser"]["Id"].stringValue
                            if otherUserId == opponentUserId {
                                // Get converstion idconverstion
                                let conversationId = item["ConversationId"].stringValue
                                UserDefaults.standard.set(conversationId, forKey: "conversationIdFirst")
                                // If contains not send post request
                                print("Contains NOT send post request")
                                
                                // Message collection path
                                let messagesBaseURL = Constants.GET_MESSAGE_COLLECTIONS
                                let messagesPath = messagesBaseURL + updatedId + "?" + "ConversationId" + "=" + conversationId
                                // Get collection of messages
                                
                                
                                Alamofire.request(messagesPath).validate().responseJSON { response in
                                    switch response.result {
                                    case .success:
                                        if((response.result.value) != nil) {
                                            let messageCollection = JSON(response.result.value!)
                                            print("MessageColllection", messageCollection)
                                            
                                            for messageItem in messageCollection.arrayValue {
                                                let senderId = messageItem["FromUser"]["Id"].stringValue
                                                let firstName = messageItem["FromUser"]["FirstName"].stringValue
                                                let toUserPhoto = "edit_button"//messageItem["FromUser"]["PhotoUrl"].stringValue
                                                let messageInfo = messageItem["Message"].stringValue
                                                let messageSent = messageItem["MessageSent"].stringValue
                                                print("MESSAGE SENT TEST", messageSent)
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                                let dateObj = dateFormatter.date(from: messageSent)
                                                let messageData = Messages(text: messageInfo, senderId: senderId, senderDisplayName: firstName, date: dateObj, isMediaMessage: false, imageUrl: toUserPhoto)
                                                
                                                self.messages.append(messageData)
                                            }
                                            DispatchQueue.main.async {
                                                self.collectionView?.reloadData()
                                            }
                                        }
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                                
                                break
                            } else {
                                print("Not contains send post request for creating new conversation")
                                UserDefaults.standard.set("NotContainsFirst", forKey: "conversationIdFirst")
                            }
                        }
                    }
                    
                    let conversationIdData = UserDefaults.standard.string(forKey: "conversationIdFirst")
                    if conversationIdData == "NotContainsFirst" {
                        print("NotContainsFirst create ui")
                        self.getCenterUiInfo(opponentUserIdInfo: opponentUserId!)
                    }else {
                        self.messgaeInfoView.isHidden = true
                       
                       let sectionId = UserDefaults.standard.string(forKey: "sectionId")
                         if sectionId == "comesFromMatchSection" {
                            let getUserEndPoint = Constants.GET_USER_ENDPOINT + opponentUserId!
                            
                            Alamofire.request(getUserEndPoint).validate().responseJSON { response in
                                switch response.result {
                                case .success:
                                    if let result = response.result.value {
                                        let responseDict = result as! [String : Any]
                                        let userName = responseDict["FirstName"] as? String
                                        if userName != "" {
                                            self.showHeaderView(userName: userName!)
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else {
                        // Message collection path
                        let messagesBaseURL = Constants.GET_MESSAGE_COLLECTIONS
                        let messageConversationId = UserDefaults.standard.string(forKey: "messageConversationId")
                        let updatedConvId: String = messageConversationId!
                        
                        let messagesPath = messagesBaseURL + updatedId + "?" + "ConversationId" + "=" + updatedConvId
                        // Get collection of messages
                        
                        Alamofire.request(messagesPath).validate().responseJSON { response in
                            switch response.result {
                            case .success:
                                if((response.result.value) != nil) {
                                    let messageCollection = JSON(response.result.value!)
                                    print("MessageCollection", messageCollection)
                                    
                                    for messageItem in messageCollection.arrayValue {
                                        
                                        let matchedAt = messageItem["MatchedAt"].stringValue
                                        UserDefaults.standard.set(matchedAt, forKey: "opponentUserMatched")
                                        
                                        let toUserName = messageItem["ToUser"]["FirstName"].stringValue
                                        self.showHeaderView(userName: toUserName)
                                        return
                                    }
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    }
                } else {
                    print("EMPTY")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func showHeaderView(userName: String) {
        
        // Retrive opponenet user matched infoif
        let olderDate = UserDefaults.standard.string(forKey: "opponentUserMatched")
        if !(olderDate == nil) {
       // let sectionId = UserDefaults.standard.string(forKey: "sectionId")

        let fullDateFormatter = DateFormatter()
       // if sectionId == "comesFromMatchSection" {
            fullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
     //   }   else {
          //  fullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
       // }

        let dateObj = fullDateFormatter.date(from: olderDate!)
        let isDate = NSCalendar.current.isDateInToday(dateObj!)

        if isDate == true {
            let date = Date()
            let formatter = DateFormatter()
            // formatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
            formatter.dateFormat = "hh:mm a"
            formatter.locale = NSLocale.system

            let currentTime: String = formatter.string(from: date)
            print("My Current Time is \(currentTime)")

            // Convert date
            let currentTimeFormatter = DateFormatter()
            currentTimeFormatter.dateFormat = "hh:mm a"
            let currentTimeObj = currentTimeFormatter.date(from: currentTime)

            // Hour obj
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            let matchedTime: String = dateFormatter.string(from: dateObj!)
            print("hourObj is \(matchedTime)")

            // Convert date
            let matchedTimeFormatter = DateFormatter()
            matchedTimeFormatter.dateFormat = "hh:mm a"
            let matchedTimeObj = matchedTimeFormatter.date(from: matchedTime)

            // Compare times
            let difference = Calendar.current.dateComponents([.hour, .minute], from: currentTimeObj!, to: matchedTimeObj!)
            var formattedString = String(format: "%02ld", difference.hour!)
            print(formattedString)

            if formattedString.hasPrefix("-") {
                formattedString.remove(at: formattedString.startIndex)
            }
            let headerLabel = UILabel(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 70, width: self.view.frame.width, height: 30))
            
            headerLabel.minimumScaleFactor = 0.5
            headerLabel.numberOfLines = 1
            headerLabel.adjustsFontSizeToFitWidth = true
            headerLabel.textAlignment = NSTextAlignment.center
            headerLabel.text = ""
            headerLabel.text = "You matched with \(userName) \(formattedString) hours ago"
            self.view.addSubview(headerLabel)

        }else {
            
            let dayDateFormatter = DateFormatter()
            dayDateFormatter.dateFormat = "MM/dd/yyyy"
            let dateToString = dayDateFormatter.string(from: dateObj!)

            let headerLabel = UILabel(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 70, width: self.view.frame.width, height: 30))
            headerLabel.minimumScaleFactor = 0.5
            headerLabel.numberOfLines = 1
            headerLabel.adjustsFontSizeToFitWidth = true
            headerLabel.textAlignment = NSTextAlignment.center
            headerLabel.text = ""
            headerLabel.text = "You matched with \(userName) on \(dateToString)"
            self.view.addSubview(headerLabel)
        }
        }
    }
    
    
    func createCenter(userPhoto: String, userName: String) {
        let chatImage = iOSImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        chatImage.center = self.view.center
        messgaeInfoView.frame = self.view.frame
        self.view.addSubview(messgaeInfoView)
        messgaeInfoView.addSubview(chatImage)
        
        // The image to download
        let remoteImageURL = URL(string: userPhoto)
        if userPhoto == "default_photo" {
            chatImage.image = UIImage(named: "default_photo")
            chatImage.contentMode = UIViewContentMode.scaleToFill
            
        }else {
            // Use Alamofire to download the image
            Alamofire.request(remoteImageURL!, method: .get).responseImage { response in
                guard response.result.value != nil else {
                    // Handle error
                    return
                }
                if let data = response.data {
                    chatImage.image = UIImage(data: data)
                    chatImage.contentMode = UIViewContentMode.scaleToFill
                }
            }
        }

        // Retrive opponenet user matched infoif
        let olderDate = UserDefaults.standard.string(forKey: "opponentUserMatched")
        if olderDate == nil {
            // First time only
            let chatLabel = UILabel(frame: CGRect(x: self.view.frame.origin.x, y: chatImage.frame.origin.y - 30, width: self.view.frame.width, height: 30))
            chatLabel.minimumScaleFactor = 0.5
            chatLabel.numberOfLines = 1
            chatLabel.adjustsFontSizeToFitWidth = true
            chatLabel.textAlignment = NSTextAlignment.center
            chatLabel.text = "You matched with \(userName) just now"
            messgaeInfoView.addSubview(chatLabel)
        }else {
        
        let fullDateFormatter = DateFormatter()
            fullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
     
        let dateObj = fullDateFormatter.date(from: olderDate!)
        let isDate = NSCalendar.current.isDateInToday(dateObj!)
        
        if isDate == true {
            let date = Date()
            let formatter = DateFormatter()
            // formatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
            formatter.dateFormat = "hh:mm a"
            formatter.locale = NSLocale.system
            
            let currentTime: String = formatter.string(from: date)
            print("My Current Time is \(currentTime)")
            
            // Convert date
            let currentTimeFormatter = DateFormatter()
            currentTimeFormatter.dateFormat = "hh:mm a"
            let currentTimeObj = currentTimeFormatter.date(from: currentTime)
            
            // Hour obj
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            let matchedTime: String = dateFormatter.string(from: dateObj!)
            print("hourObj is \(matchedTime)")
            
            // Convert date
            let matchedTimeFormatter = DateFormatter()
            matchedTimeFormatter.dateFormat = "hh:mm a"
            let matchedTimeObj = matchedTimeFormatter.date(from: matchedTime)
            
            // Compare times
            let difference = Calendar.current.dateComponents([.hour, .minute], from: currentTimeObj!, to: matchedTimeObj!)
            var formattedString = String(format: "%02ld", difference.hour!)
            print(formattedString)
            
            if formattedString.hasPrefix("-") {
                formattedString.remove(at: formattedString.startIndex)
            }
            let chatLabel = UILabel(frame: CGRect(x: self.view.frame.origin.x, y: chatImage.frame.origin.y - 30, width: self.view.frame.width, height: 30))
            chatLabel.minimumScaleFactor = 0.5
            chatLabel.numberOfLines = 1
            chatLabel.adjustsFontSizeToFitWidth = true
            chatLabel.textAlignment = NSTextAlignment.center
            chatLabel.text = "You matched with \(userName) \(formattedString) hours ago"
            messgaeInfoView.addSubview(chatLabel)
            
        }else {
            let dayDateFormatter = DateFormatter()
            dayDateFormatter.dateFormat = "MM/dd/yyyy"
            let dateToString = dayDateFormatter.string(from: dateObj!)
            
            let chatLabel = UILabel(frame: CGRect(x: self.view.frame.origin.x, y: chatImage.frame.origin.y - 30, width: self.view.frame.width, height: 30))
            chatLabel.minimumScaleFactor = 0.5
            chatLabel.numberOfLines = 1
            chatLabel.adjustsFontSizeToFitWidth = true
            chatLabel.textAlignment = NSTextAlignment.center
            chatLabel.text = "You matched with \(userName) \(dateToString)"
            messgaeInfoView.addSubview(chatLabel)
        }
        }
    }
    
    
    func createHeader(userPhoto: String, userName: String) {
        if self.navigationController == nil {
            return
        }
    
        let navView = UIView()
        navView.backgroundColor = .clear
        navView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: 300, height: 50))
     
        let label = UILabel()
        label.textAlignment = NSTextAlignment.left
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = userName
       
        
        let image = iOSImageView()
        
        // The image to download
        let remoteImageURL = URL(string: userPhoto)
        if userPhoto == "default_photo" {
            image.image = UIImage(named: "default_photo")
            // To maintain the image's aspect ratio:
            image.frame = CGRect(x: navView.frame.origin.x, y: navView.frame.origin.y, width: 50, height: 50)
            label.frame = CGRect(x: image.frame.origin.x + 50, y: navView.frame.origin.y + 2, width: 200, height: 40)
            image.contentMode = UIViewContentMode.scaleAspectFit
            navView.addSubview(label)
            navView.addSubview(image)
            
        }else {
            // Use Alamofire to download the image
            Alamofire.request(remoteImageURL!, method: .get).responseImage { response in
                guard response.result.value != nil else {
                    // Handle error
                    return
                }
                if let data = response.data {
                    image.image = UIImage(data: data)
                    image.frame = CGRect(x: navView.frame.origin.x, y: navView.frame.origin.y, width: 50, height: 50)
                    label.frame = CGRect(x: image.frame.origin.x + 50, y: navView.frame.origin.y + 2, width: 200, height: 40)
                    image.contentMode = UIViewContentMode.scaleAspectFit
                    
                    // Add both the label and image view to the navView
                    navView.addSubview(label)
                    navView.addSubview(image)
                }
            }
        }
       
        self.navigationItem.titleView = navView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.titleWasTapped))
        navView.isUserInteractionEnabled = true
        navView.addGestureRecognizer(recognizer)
    }
    
    
    @objc private func titleWasTapped() {
        self.chatUserInfo.removeAll()
        self.chatImageUrl.removeAll()
        
        // Opponenet user id
        let opponentUserId = UserDefaults.standard.string(forKey: "opponentUserId")
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + opponentUserId!
        
        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let responseDict = result as! [String : Any]
                    let data = responseDict["PhotoUrl"] as! String
                    let firstName = responseDict["FirstName"] as! String
                    let aboutUser = responseDict["About"] as! String
                    
                    if data != "" {
                        self.chatImageUrl.append(data)
                        self.chatUserInfo.append(firstName)
                        self.chatUserInfo.append(aboutUser)
                      
                        let detail = ProfileDetailViewController.instantiateFromStoryboard()
                        detail.profileInfo = self.chatUserInfo
                        
                        let chatSwiftyData = JSON(response.result.value!)
                        let userPhotos = chatSwiftyData["Photos"].arrayValue
                        
                        for item in userPhotos {
                            let userPhoto = item["PhotoURL"].stringValue
                            if !(self.chatImageUrl.contains(userPhoto)) {
                                self.chatImageUrl.append(userPhoto)
                            }
                        }
                        
                        detail.userImageInfo = self.chatImageUrl
                        self.present(detail, animated: true, completion: nil)
                        
                    }else {
                        self.chatImageUrl.append("default_photo")
                        self.chatUserInfo.append(firstName)
                        self.chatUserInfo.append(aboutUser)
                        
                        let detail = ProfileDetailViewController.instantiateFromStoryboard()
                        detail.profileInfo = self.chatUserInfo
                        detail.userImageInfo = self.chatImageUrl
                        self.present(detail, animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
  
    func setupBackButton() {
        UserDefaults.standard.set("comesFromChat", forKey: "dedicate")

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
        // Move Controller

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = sb.instantiateViewController(withIdentifier: "MainViewController")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainViewController
    }

  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
      
        return messages[indexPath.item].senderId()  == self.senderId() ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        let senderNameInfo = message.senderDisplayName
        let index = senderNameInfo().characters.index(senderNameInfo().startIndex, offsetBy: 0)
        let startChar = senderNameInfo()[index]
        let charString = String(startChar)
        let senderTilte = JSQMessagesAvatarImageFactory().avatarImage(withUserInitials: charString, backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12))
    
        return senderTilte
    }
    
    var messageDataCheck: String!
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
  
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let messageDate = self.messages[indexPath.item].date
            print("messageDate test",messageDate)
            let dateToString = dateFormatter.string(from: messageDate())
            print("dateToString test",dateToString)

        
        if indexPath.item > 0 {
         let previouseDay = self.messages[indexPath.item - 1].date
            let previousDateToString = dateFormatter.string(from: previouseDay())
            
            if dateToString == previousDateToString {
                
            } else {
                let attributedString = NSAttributedString(string: dateToString)
                
                return attributedString
            }
        }else {
            let attributedString = NSAttributedString(string: dateToString)
            
            return attributedString
        }
       
        return nil
    }
    
    

    override func senderDisplayName() -> String {
        return (currentUser?.firstName)!
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
      
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let messageDate = self.messages[indexPath.item].date
        let dateToString = dateFormatter.string(from: messageDate())
        
        if indexPath.item > 0 {
            let previouseDay = self.messages[indexPath.item - 1].date
            let previousDateToString = dateFormatter.string(from: previouseDay())
            
            if dateToString == previousDateToString {
                
            } else {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }else {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
    
        return 0.0
    }
}
