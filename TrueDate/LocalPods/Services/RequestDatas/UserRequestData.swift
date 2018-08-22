////
////  UserRequestData.swift
////  JoinMe
////
////  Created by Nareg on 2/17/17.
////  Copyright © 2017 Friends. All rights reserved.
////
//
//import UIKit
//
//struct UserRequestData {
//    
//    struct PlacesData {
//        var country = ""
//        var city = ""
//        var loadMore = 0
//        
//        var JSON :[String: Any] {
//            return ["country_ed": country,
//                    "city_ed": city,
//                    "position":loadMore]
//        }
//    }
//    
//    struct AnswersRequestData {
//        var id = ""
//        var user_id = ""
//        var linked_user = ""
//        var message = ""
//        var linked = ""
//        var user = ""
//        var image = ""
//        var loadMore = 0
//        
//        var JSON:[String: Any]{
//            
//        return ["message": message]
//            
//        }
//    }
//    
//    struct UserUpdateRequstData {
//        
//        var user_id = ""
//        var firstName = ""
//        var lastName = ""
//        var sex = ""
//        var country = ""
//        var city = ""
//        var age = ""
//        var vk_social = ""
//        var instagram_social = ""
//        var fb_social = ""
//        var about_me = ""
//        
//        
//        init(with user: UserModel) {
//            user_id = user.id
//            firstName = user.firstName
//            lastName = user.lastName
//            sex = user.sex
//            city = user.city
//            country = user.country
//            age = user.age
//            vk_social = user.vk_social
//            instagram_social = user.instagram_social
//            fb_social = user.fb_social
//            about_me = user.about_me
//        }
//
//        var JSON:[String: Any] {
//            
//        return ["user_id": user_id,
//                "firstName": firstName,
//                "lastName": lastName,
//                "sex": sex,
//                "country": country,
//                "city": city,
//                "age": age,
//                "vk_social": vk_social,
//                "instagram_social": instagram_social,
//                "fb_social" : fb_social,
//                "about_me": about_me]
//        }
//        
//    }
//    struct UserImageUpdateData{
//
//        var user_id = ""
//        var image = ""
//        var JSON:[String: Any]{
//
//            return ["user_id": user_id,
//                    "image": image]
//        }
//
//    }
//    struct ReportData {
//        var user_id = ""
//        var to_report = ""
//        var message = ""
//        var JSON:[String: Any]{
//            
//            return ["user_id": user_id,
//                   "to_report": to_report,
//                    "message": message]
//        }
//        
//    }
//    
//    struct FollowData {
//        var user_id = ""
//        var user_id_following = ""
//        
//        var JSON: [String:String]{
//            return ["user_id":user_id,"user_id_following":user_id_following]
//        }
//    }
//    
//    struct PasswordData {
//        var user_id = ""
//        var old_password = ""
//        var new_password = ""
//        
//        var JSON: [String:Any]{
//            return ["user_id":user_id, "old_password":old_password, "new_password":new_password]
//        }
//    }
//    
//    struct EmailData {
//        var user_id = ""
//        var new_email = ""
//        var password = ""
//        
//        var JSON: [String: Any]{
//            return["user_id": user_id, "new_email": new_email, "password":password]
//        }
//    }
//    struct PhoneData {
//        var user_id = ""
//        var new_phone = ""
//        var password = ""
//        
//        var JSON: [String:Any]{
//            return["user_id":user_id, "new_phone":new_phone, "password":password]
//        
//        }
//    
//    }
//  
//}
