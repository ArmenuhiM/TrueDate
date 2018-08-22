//
//  PrematchViewController.swift
//  TrueDate
//
//  Created by Armenuhi on 1/16/18.
//  Copyright © 2018 Company. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class PrematchViewController: UIViewController {

    @IBOutlet weak var matchText: UILabel!
    @IBOutlet weak var currentUserImage: iOSImageView!
    @IBOutlet weak var opponentUserImage: iOSImageView!
    @IBOutlet weak var sendMessage: iOSCommonButton!
    @IBOutlet weak var keepPlaying: iOSCommonButton!
    
    var currentUser = UserRequestsService().currentUser
    var userDataFromServer = [[String:Any]]()
    var userPhoto: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentUserPhoto()
        
        let opponentUserId = UserDefaults.standard.string(forKey: "opponentUserId")

        // Get current user Id
        let getUserEndPoint = Constants.GET_USER_ENDPOINT + opponentUserId!
        
        Alamofire.request(getUserEndPoint).validate().responseJSON { response in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let swiftyData = JSON(response.result.value!)
                    let userPhotos = swiftyData["Photos"].arrayValue
                    if userPhotos.count > 0 {
                        for item in userPhotos {
                            let userPhoto = item["PhotoURL"].stringValue
                            self.opponentUserImage.sd_setImage(with: URL(string: userPhoto))
                            break
                        }
                    } else {
                        self.opponentUserImage.image = UIImage(named: "default_photo")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        

        
        // Get Matched user name
        let opponentUserName = UserDefaults.standard.string(forKey: "opponentUserName")
        matchText.text = "You and " + opponentUserName! + " have liked each other."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getCurrentUserPhoto() {
        //api/Users/{id}
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
                                self.currentUserImage.image = UIImage(data: data)
                            }
                        }
                    }else {
                        self.currentUserImage.image = UIImage(named: "default_photo")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        // Move Controller
        let chatView = ChatViewController()
        let chatNavigationController = UINavigationController(rootViewController: chatView)
        present(chatNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func keepPlayingAction(_ sender: Any) {
        // Move Controller
        let _ = MainViewController()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = sb.instantiateViewController(withIdentifier: "MainViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = mainViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
