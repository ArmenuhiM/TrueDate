//
//  MessageViewController.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/07.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import SDWebImage
import Bond
import Alamofire
import SwiftyJSON

class MessageViewController: UIViewController {
    
    class func instantiateFromStoryboard() -> MessageViewController {
        let storyboard = UIStoryboard(name: "Message", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! MessageViewController
    }
    
    internal let disposeBag = DisposeBag()
    
    internal let viewModel = MessageViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    var messagesName : [String] = []
    var messagesPhoto : [String] = []
    var messagesInfo : [String] = []
    var messagesConversationId : [String] = []
    
    var matchesName : [String] = []
    var matchesPhoto : [String?] = []
    var matchesMatch : [Bool] = []
    var matcheUserId: [String] = []
    var matchesMatchId : [String] = []
    var newMessages : [Bool] = []
    var matchedAt: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MessageCollectionView", bundle: nil), forCellReuseIdentifier: "MessageCollectionView")
        self.tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    }
    
    
    
    func getNewMatchUsers() {
        let currentUser = UserRequestsService().currentUser
        let currentUserId = (currentUser?.id)!
        let userId: String = String(currentUserId)
        let baseURL = "http://true--date-secure51-ezhostingserver-com-5q1py9nvyyhw.runscope.net/api/Matches/"
        let path = baseURL + userId
        print("Path", path)
        
        // Get Converstions
        Alamofire.request(path).validate().responseJSON { response in
            switch response.result {
            case .success:
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    for item in swiftyJsonVar.arrayValue {
                        let firstName = item["User"]["FirstName"].stringValue
                        let userId = item["User"]["Id"].stringValue
                        let photoUrl = item["User"]["PhotoUrl"].stringValue
                        let newMatche = item["User"]["NewMatch"].boolValue
                        let matchId = item["MatchId"].stringValue
                        let matchedAtInfo = item["MatchedAt"].stringValue

                        self.matcheUserId.append(userId)
                        self.matchedAt.append(matchedAtInfo)
                        self.matchesName.append(firstName)
                        self.matchesPhoto.append(photoUrl)
                        self.matchesMatch.append(newMatche)
                        self.matchesMatchId.append(matchId)
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getConversations() {
        let currentUser = UserRequestsService().currentUser
        let currentUserId = (currentUser?.id)!
        let userId: String = String(currentUserId)
        let baseURL = Constants.GET_USER_CONVERSATIONS
        let path = baseURL + userId
        print("Path", path)
        
        // Get Converstions
        Alamofire.request(path).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("")
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    for item in swiftyJsonVar.arrayValue {
                        let firstName = item["OtherUser"]["FirstName"].stringValue
                        let photoUrl = item["OtherUser"]["PhotoUrl"].stringValue
                        let message = item["LastMessage"]["Message"].stringValue
                        let newMessage = item["NewMailAlert"].boolValue
                        let conversationId = item["ConversationId"].stringValue

                        self.messagesName.append(firstName)
                        self.messagesPhoto.append(photoUrl)
                        self.messagesInfo.append(message)
                        self.newMessages.append(newMessage)
                        self.messagesConversationId.append(conversationId)
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newAlertHide"), object: nil)
    
        self.messagesName.removeAll()
        self.messagesPhoto.removeAll()
        self.messagesInfo.removeAll()
        self.newMessages.removeAll()
        self.messagesConversationId.removeAll()
        
        self.matcheUserId.removeAll()
        self.matchedAt.removeAll()
        self.matchesName.removeAll()
        self.matchesPhoto.removeAll()
        self.matchesMatch.removeAll()
        self.matchesMatchId.removeAll()
        
        self.tableView.rx.itemSelected
            .subscribe(
                onNext: { indexPath in
                    let opponenetUserId = self.viewModel.messageUsers.value[indexPath.row].id
                    let messageConversationId = self.messagesConversationId[indexPath.row]
                     UserDefaults.standard.set(messageConversationId, forKey: "messageConversationId")
                   // let opponenetUserMatched = self.viewModel.messageUsers.value[indexPath.row].matchedAt
                    UserDefaults.standard.set(opponenetUserId, forKey: "opponentUserId")
                   // UserDefaults.standard.set(opponenetUserMatched, forKey: "opponentUserMatched")
                    UserDefaults.standard.set("comesFromMessageSection", forKey: "sectionId")
                    let chat = ChatViewController()
                    let navigationController = UINavigationController(rootViewController: chat)
                    self.present(navigationController, animated: true, completion: nil)
            })
            .addDisposableTo(self.disposeBag)
    
         getNewMatchUsers()
        
         getConversations()
    }
}

extension MessageViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "message", image: UIImage(named: "message"), newAlert: UIImage(named: ""))
    }
}

extension MessageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let opponenetUserId = self.matcheUserId[indexPath.row]
        UserDefaults.standard.set(opponenetUserId, forKey: "opponentUserId")
        
        let opponenetUserMatched = self.matchedAt[indexPath.row]
        UserDefaults.standard.set(opponenetUserMatched, forKey: "opponentUserMatched")
        UserDefaults.standard.set("comesFromMatchSection", forKey: "sectionId")
        
        let chat = ChatViewController()
        let navigationController = UINavigationController(rootViewController: chat)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension MessageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchesName.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath as IndexPath) as! MatchCollectionViewCell
         cell.name.text = matchesPhoto[indexPath.row]
             let thumbnail = matchesPhoto[indexPath.row]
        if thumbnail != "" {
            cell.thumbnail.sd_setImage(with: URL(string: thumbnail!)!)
        } else {
            cell.thumbnail.image = UIImage(named: "default_photo")
        }
        cell.name.text = matchesName[indexPath.row]
        let checkNewMatch = matchesMatch[indexPath.row]
        if checkNewMatch == false {
            cell.notifyNewMatch.isHidden = true
        }else {
            cell.notifyNewMatch.isHidden = false
        }

      return cell
    }
}


extension MessageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        var sectionNum: Int = 0
        
        if section == 0 {
            sectionNum = 1
        } else if section == 1{
            sectionNum = self.messagesName.count
        }
        
        return sectionNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            self.tableView.rowHeight = 120
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "MessageCollectionView", for: indexPath) as! MessageCollectionView

            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            let nib = UINib(nibName: "MatchCollectionViewCell", bundle: nil)
            cell.collectionView.register(nib, forCellWithReuseIdentifier: "MatchCollectionViewCell")
            return cell
            
        } else{
            
            self.tableView.rowHeight = 100
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
            cell.name.text = self.messagesName[indexPath.row]
            cell.message.text = self.messagesInfo[indexPath.row]
            
            let checkNewMessage = newMessages[indexPath.row]
            if checkNewMessage == false {
                cell.newMessage.isHidden = true
            }else {
                cell.newMessage.isHidden = false
            }
            
            if self.messagesPhoto[indexPath.row] != "" {
                let thumbnail = self.messagesPhoto[indexPath.row]
                cell.thumbnail.sd_setImage(with: URL(string: thumbnail)!)
            } else {
                cell.thumbnail.image = UIImage(named: "default_photo")
            }
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("MessageSectionHeaderView", owner: self, options: nil)?.first as! MessageSectionHeaderView
        
        if section == 0 {
            view.title.text = "Matches"
        } else if section == 1 {
         view.title.text = "Messages"
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
