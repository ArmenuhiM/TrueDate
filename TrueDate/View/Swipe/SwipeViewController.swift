//
//  SwipeViewController.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/07.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Koloda
import Pulsator
import RxSwift
import RxCocoa
import Bond
import RealmSwift
import Alamofire
import AlamofireImage
import SwiftyJSON


class SwipeViewController: UIViewController, DetailViewControllerDelegate {
    
    fileprivate let disposeBag = DisposeBag()
    
    internal let viewModel = SwipeViewModel()
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var image: UIImageView!
    var chatOpponentUserId: String!
    var opponentImageUrl = [String]()

    
    var messagesAlertTrue : [Bool] = []
    
    var currentUser = UserRequestsService().currentUser
    var user: User?
    var selectedImage: UIImageView!
    var previousIndex: Int?
    
    let pulsator = Pulsator()
    
    var userPhotoDataFromServer = [[String:Any]]()

    class func instantiateFromStoryboard() -> SwipeViewController {
        let storyboard = UIStoryboard(name: "Swipe", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SwipeViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.messagesAlertTrue.removeAll()
        
        addUserImage()
        
        let dedicateInfo = UserDefaults.standard.string(forKey: "dedicate")
        if dedicateInfo == "comesFromChat" {
            UserDefaults.standard.set("", forKey: "dedicate")
        } else {
            viewModel.swipableUsers
                .asObservable()
                .subscribe(
                    onNext: {[weak self] users in
                        self?.kolodaView.reloadData()
                    })
                .addDisposableTo(disposeBag)
            
            // Register to receive notification in your class
            NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
            
            let userUpdateNotification = Notification.Name("passOpponenetId")
            NotificationCenter.default.addObserver(self, selector: #selector(updateUser(not:)), name: userUpdateNotification, object: nil)
        }
      
       getConversations()
    }
  
    func updateUser(not: Notification) {
        // userInfo is the payload send by sender of notification
        if let userInfo = not.userInfo {
            // Safely unwrap the name sent out by the notification sender
            if let userName = userInfo["name"] as? String {
                print(userName)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.TindestColor.lightGray
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        image.layer.superlayer?.insertSublayer(pulsator, below: image.layer)
        pulsator.backgroundColor = UIColor.TindestColor.mainRed.cgColor
        pulsator.radius = 180.0
        pulsator.numPulse = 3
        startPulse()
    }
    
  
    
    // handle notification
    func showSpinningWheel(_ notification: NSNotification) {
        self.showAlertView("No search results, try changing your preferences to see more", message: nil, completion: nil)
    }
    
    internal func startPulse(){
        if(!pulsator.isPulsating){
            pulsator.start()
        }
    }
    
    internal func stopPulse(){
        pulsator.stop()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        image.layer.layoutIfNeeded()
        pulsator.position = image.layer.position
    }
    
    @IBAction func returnTapped(_ sender: Any) {
      kolodaView?.revertAction()
    }
    
    @IBAction func nopeTapped(_ sender: Any) {
        kolodaView?.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        kolodaView?.swipe(SwipeResultDirection.right)
    }
    
    
     // MARK: - Like User
    func likeUser(targetId: Int, preMatchId: Bool) {
        // Get current user Id
        let currentUserId = (currentUser?.id)!
        
        // Get target user Id
        let targetUserId = targetId
        
        // Get preMatche Id
        let preMatcheData = preMatchId
        
        // Parameters for post requset
        var parameters = [String:Any]()
        parameters["SourceId"] = currentUserId
        parameters["TargetId"] = targetUserId
        parameters["Likes"] = true
        
        let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
        
    Alamofire.request(Constants.LIKE_DISLIKE_USER_ENDPOINT, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
        
        if preMatcheData == true {
            // Move Controller
            if let preMatchView =  self.getViewControllerWithStoryBoard(sbName: "Prematch", vcIndentifier: "PreMatchView") {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = preMatchView
            }
        }
    }
    
    
     // MARK: - Dislike User
    func disLikeUser(targetId: Int) {
        // Get current user Id
        let currentUserId = (currentUser?.id)!
        
        // Get target user Id
        let targetUserId = targetId
        
        // Parameters for post requset
        var parameters = [String:Any]()
        parameters["SourceId"] = currentUserId
        parameters["TargetId"] = targetUserId
        parameters["Likes"] = false
        
        let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
        
        Alamofire.request(Constants.LIKE_DISLIKE_USER_ENDPOINT, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    for item in swiftyJsonVar.arrayValue {
                       
                        let newMessage = item["NewMailAlert"].boolValue
                        if newMessage == true {
                          self.messagesAlertTrue.append(newMessage)
                        }
                    }
                    print("messagesAlertTrue swipe", self.messagesAlertTrue)
                    if !(self.messagesAlertTrue.isEmpty) {
                        // post a notification
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newAlert"), object: nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

    
    
    func addUserImage() {
        // Get current user Id
        let currentUserId = (currentUser?.id)!
        let updatedId: String = String(currentUserId)
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + updatedId
        
        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            
            case .success:
                if let result = response.result.value {
                    let responseDict = result as! [String : Any]
                    let data = responseDict["PhotoUrl"] as? String
                    if data != "" {
                        // The image to download
                        let remoteImageURL = URL(string: data!)
                        // Use Alamofire to download the image
                        Alamofire.request(remoteImageURL!, method: .get).responseImage { response in
                            guard response.result.value != nil else {
                                // Handle error
                                return
                            }
                            if let data = response.data {
                                self.image.image = UIImage(data: data)
                            }
                        }
                    }else {
                        self.image.image = UIImage(named: "default_photo")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}



extension SwipeViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "swipe", image: UIImage(named: "logo"), newAlert: UIImage(named: ""))
    }
}

extension SwipeViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
            //pulsator.stop()
         return viewModel.swipableUsers.value.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView: CardView = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CardView
        cardView.user = viewModel.swipableUsers.value[index]
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("SwipeOverlayView",owner: self, options: nil)![0] as? SwipeOverlayView
    }
}

extension SwipeViewController: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
         self.opponentImageUrl.removeAll()

        let detail = DetailViewController.instantiateFromStoryboard()
        detail.delegate = self
        detail.user = viewModel.swipableUsers.value[index]
        let userId = String(viewModel.swipableUsers.value[index].id)
        
        // Get current user Id
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + userId
        
        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                        let swiftyData = JSON(response.result.value!)
                        let userPhotos = swiftyData["Photos"].arrayValue
                        
                        for item in userPhotos {
                            let userPhoto = item["PhotoURL"].stringValue
                                self.opponentImageUrl.append(userPhoto)
                        }
                        detail.detailImageInfo = self.opponentImageUrl
                        self.present(detail, animated: true, completion: nil)
                        
                    }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.viewModel.cardDidRunOut.onNext()
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        self.previousIndex = index
        let userData = viewModel.swipableUsers.value[index]
        let userId = userData.id
        let preMatch = userData.preMatch
        let swipeDirection: String? = String(describing: direction)
       // let opponentUserPhoto = userData.photoUrl
        let opponentUserName = userData.firstName

        if preMatch == true {
           // UserDefaults.standard.set(opponentUserPhoto, forKey: "opponentUserPhoto")
            UserDefaults.standard.set(opponentUserName, forKey: "opponentUserName")
            UserDefaults.standard.set(userId, forKey: "opponentUserId")
        }
        
        if swipeDirection == "right" {
            // Like user
            likeUser(targetId: userId!, preMatchId: preMatch!)
        }else{
            // Dislike user
            disLikeUser(targetId:userId!)
        }
    }
}

//extension SwipeViewController {
//    
//    func copyImageView() -> UIImageView {
//        let image = UIImageView(image: self.selectedImage.image)
//        image.frame = self.selectedImage.convert(self.selectedImage.bounds, to: self.parent?.view)
//        image.contentMode = self.selectedImage.contentMode
//        return image
//    }
//}

