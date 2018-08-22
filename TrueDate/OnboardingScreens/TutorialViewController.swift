//
//  TutorialViewController.swift
//  PacketApp
//
//  Created by Armenuhi on 5/11/17.
//  Copyright © 2017 BeesNest. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    var dict : [String : AnyObject]!
    var networkStatus: Bool!
    var requestData = RegisterRequestData()
   
    
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
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
        return networkStatus
    }
    
    
    func statusManager(_ notification: NSNotification) {
        let result = updateUserInterface()
        if result == true {
            print("True===", true)
        }else {
            print("False====", false)
        }
    }

    
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginBtn.layer.cornerRadius = 25
       
        fbLoginBtn.titleLabel?.minimumScaleFactor = 0.6;
        fbLoginBtn.titleLabel?.adjustsFontSizeToFitWidth = true;
        
         NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        let result = updateUserInterface()
        if result == true {
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                            //fbLoginManager.logOut()
                        }
                    }
                }
            }
        }else {
            self.showAlertView("Error", message: "No internet connection", completion: nil)
        }
    }
    
    //MARK: Get Facebook user data
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, age_range, first_name, last_name, updated_time, email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    self.dict = result as! [String : AnyObject]
                    
                    let json = JSON(self.dict)
                    print("JSON", json)
                    
                    //Getting a string from a JSON Dictionary
                    let id = json["id"].intValue
                    let lastName = json["last_name"].stringValue
                    let email = json["email"].stringValue
                    let gender = json["gender"].stringValue
                    let updatedTime = json["updated_time"].stringValue
                    let firstName = json["first_name"].stringValue
                    let ageRange = json["age_range"].dictionary
                    let min = ageRange?["min"]?.intValue
                    
                    self.requestData.id = id
                    self.requestData.about = "About Me"
                    self.requestData.ageRange = min!
                    self.requestData.gender = gender
                    self.requestData.birthday = "1989-02-01T00:00:00"
                    self.requestData.firstName = firstName
                    self.requestData.lastName = lastName
                    self.requestData.email = email
                    self.requestData.updatedTime = updatedTime
                    
                    let deviceToken = UserDefaults.standard.string(forKey: "deviceToken")

                    UserRequestsService().registerUser(registerData: self.requestData, success: { (user:UserModel) in
                        
                        let preferencesUrl = Constants.POST_DEVICETOKEN
                        
                        // Get user Id
                        let currentUserId = id
                        let updatedId: Int? = Int(currentUserId)
                        
                        var parameters = [String:Any]()
                        parameters["UserId"] = updatedId
                        parameters["DeviceToken"] = deviceToken
                        
                        let headers: HTTPHeaders = ["Authorization": "test", "Accept": "application/json", "Content-Type" :"application/json"]
                        Alamofire.request(preferencesUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                        }
                  
                    }, failer: { (error:String) in
                        
                    })
                }
            })
        }
    }
    
   
    

    // MARK: Move to Next View Controller
    func moveController() {
     
        // Move Controller
        let _ = MainViewController()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = sb.instantiateViewController(withIdentifier: "MainViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = mainViewController
        appDelegate.window?.makeKeyAndVisible()
    }

    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int) {
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int) {
    }
}
