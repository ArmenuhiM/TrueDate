//
//  UserRequestsService.swift+
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation

class UserRequestsService {
    
    var tutorialViewController = TutorialViewController()
    
    var currentUser: UserModel? {
        let cUser = uiRealm.objects(UserModel.self).filter("currentUser == true")
        return cUser.last
    }
    
    func registerUser(registerData: RegisterRequestData, success:@escaping (UserModel)->Void, failer:@escaping (String)->Void ) {

        let params = registerData.JSON
        JMLoading.sharedInstance.showActivityIndicator()
        ApiClientService.postRequest(Constants.REGISTER_ENDPOINT, params: params, success: { (responce: Any) in
            JMLoading.sharedInstance.hideActivityIndicator()
            
            if let failerText = ApiClientService.processError(responce) as? String {
                if failerText == "1" {
                    failer("Failed")
                    return
                }
            }
            // Query all users id from Realm
            // Checking if user from this is already exists quit.
            let queryUserId = Set(uiRealm.objects(UserModel.self).value(forKey: "id") as! [Int])
            if let userData = responce as? [String: AnyObject] {
                let existedUserId = userData["User"]?["Id"] as! Int
                if queryUserId.contains(existedUserId) {
                }else {
                    let loginUser = UserModel.init(json: userData["User"] as! [String : Any])
                    loginUser.currentUser = true
                    RealmWrapper.sharedInstance.addObjectInRealmDB(loginUser)
                    success(loginUser)
                }
            }
            print(responce)
            self.tutorialViewController.moveController()

        }) { (error: String) in
            JMLoading.sharedInstance.hideActivityIndicator()
            failer(error)
        }
    }
    
    func addUserProfileImage(imageData: ImageRequestData, success:@escaping (ImageModel)->Void, failer:@escaping (String)-> Void) {
        
        let params = imageData.JSON
        
        JMLoading.sharedInstance.showActivityIndicator()
        ApiClientService.postRequest(Constants.POST_PHOTO_ENDPOINT, params: params, success: { (responce: Any) in
            JMLoading.sharedInstance.hideActivityIndicator()
            
            if let failerText = ApiClientService.processError(responce) as? String {
                if failerText == "1" {
                    failer("Failed")
                    return
                }
            }
        }) { (error: String) in
            JMLoading.sharedInstance.hideActivityIndicator()
            failer(error)
        }
    }
}
