//
//  ProfileViewController.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/07.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import FacebookLogin
import FBSDKLoginKit
import RealmSwift
import Alamofire
import AlamofireImage
import SwiftyJSON

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: iOSImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    var imageRequest = ImageRequestData()
    var currentUser = UserRequestsService().currentUser
    var networkStatus: Bool!
    
    var userImageUrl = [String]()
    var profileUserInfo = [String]()
    
    class func instantiateFromStoryboard() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ProfileViewController
    }
    
    
    // MARK: - Reachability
    func updateUserInterface() -> Bool {
        guard let status = Network.reachability?.status else { return networkStatus }
        switch status {
        case .unreachable:
            networkStatus = false
        case .wifi:
            networkStatus = true
        case .wwan:
            networkStatus = true
        }
        print("Good job")
        return networkStatus
    }
    
    
    func statusManager(_ notification: NSNotification) {
        let result = updateUserInterface()
        if result == true {
            print("True", true)
        }else {
            print("False", false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newAlertHide"), object: nil)
        
        // Set user name data
        self.nameLabel.text = currentUser?.firstName
        
        // Check Internet connection
        let result = updateUserInterface()
        if result == true {
        
            addUserImage()
        } else {
            self.showAlertView("Error", message: "No internet connection", completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.TindestColor.lightGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
    
    
    @IBAction func addPhotos(_ sender: UIButton) {
        if let editView =  self.getViewControllerWithStoryBoard(sbName: "Edit", vcIndentifier: "NextNavViewController") {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = editView
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
                            // Do stuff with your image
                            self.addPhotoButton?.setTitle("", for: .normal)
                            
                            if let data = response.data {
                                self.userImageView.image = UIImage(data: data)
                            }
                        }
                    }else {
                        //self.userImageView.image = UIImage(named: "default_photo")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func openSettings(_ sender: UIButton) {
        // Move Controller
        if let settingsView =  self.getViewControllerWithStoryBoard(sbName: Constants.settingsView, vcIndentifier: Constants.settingsView) as! iOSCommonNavigationController! {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = settingsView
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
       if self.userImageView.image != nil {
             self.profileUserInfo.removeAll()
             self.userImageUrl.removeAll()
            
            // Get current user Id
            let currentUserId = (currentUser?.id)!
            let updatedId: String = String(currentUserId)
            let getUserEndPoint = Constants.GET_USER_ENDPOINT + updatedId
            
            Alamofire.request(getUserEndPoint).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let result = response.result.value {
                        let responseDict = result as! [String : Any]
                        let data = responseDict["PhotoUrl"] as! String
                        let firstName = responseDict["FirstName"] as! String
                        let aboutUser = responseDict["About"] as! String

                        if data != "" {
                            self.userImageUrl.append(data)
                            self.profileUserInfo.append(firstName)
                            self.profileUserInfo.append(aboutUser)
                            //
                            let detail = ProfileDetailViewController.instantiateFromStoryboard()
                            detail.profileInfo = self.profileUserInfo
                           
                            
                            let swiftyData = JSON(response.result.value!)
                            print("swiftyData", swiftyData)
                            let userPhotos = swiftyData["Photos"].arrayValue
                            
                            for item in userPhotos {
                                let userPhoto = item["PhotoURL"].stringValue
                                if !(self.userImageUrl.contains(userPhoto)) {
                                self.userImageUrl.append(userPhoto)
                                }
                            }
                            
                            detail.userImageInfo = self.userImageUrl
                            self.present(detail, animated: true, completion: nil)
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }else {
            self.showActionSheetInController(sender, title: nil, message: nil, otherButtonTitles: ["Take a photo"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil) { (action:String) in
                if action == "Take a photo" {
                    self.takePhoto()
                }
            }
        }
    }
    
    //MARK: UIImagePickerController  methods
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.modalPresentationStyle = .fullScreen
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.showsCameraControls = true
            cameraPicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
            
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            self.showAlertView("Device has no camera", message: nil, completion: nil)
        }
    }
    
    
    //MARK: UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var newImage: UIImage
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage.scaledToSize(newSize: CGSize.init(width: 512, height: 512))
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage.scaledToSize(newSize: CGSize.init(width: 512, height: 512))
        } else {
            newImage = UIImage.init()
        }
        userImageView?.image = newImage
        self.imageRequest.base64String = newImage.base64(format:.JPEG(0.5))!
        
        // Get user Id
        let currentUserId = (currentUser?.id)!
        print("currentUserId", currentUserId)
        let id: Int? = Int(currentUserId)
        self.imageRequest.userId = id!
        UserRequestsService().addUserProfileImage(imageData: self.imageRequest, success: { (user:ImageModel) in
            
        }, failer: { (error:String) in
            
        })
        self.addPhotoButton?.setTitle("", for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func facebookLogOut(_ sender: UIButton) {
        fbLoginManager.logOut()
        if let startView =  self.getViewControllerWithStoryBoard(sbName: "Main", vcIndentifier: "starView") {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = startView
        }
    }
    
    
}

extension ProfileViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "profile", image: UIImage(named: "profile"), newAlert: UIImage(named: ""))
    }
}



