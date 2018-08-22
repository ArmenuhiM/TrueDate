//
//  RegisterRequestData.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

/*struct RegisterRequestData {
//    var id = 0
//    var about = ""
//    var ageRange = 0
//    var birthday = "" //date
//    var context = ""
//    var cover = ""
//    var currency = ""
//    var devices = ""
//    var education = ""
//    var email = ""
//    var firstName = ""
//    var gender = ""
//    var hometown = ""
//    var installType = ""
//    var isSharedLogin = true
//    var isVerified = true
//    var languages = ""
//    var lastName = ""
//    var link = ""
//    var locale = ""
//    var location = ""
//    var middleName = ""
//    var name = ""
//    var relationshipStatus = ""
//    var religion = ""
//    var shortName = ""
//
//    var sports = ""
//    var timezone = 0
//    var updatedTime = "" //date
//    var verified = true
//    var website = ""
//    var work = ""
//    var photos = ""
//    var website = ""
//
//
//
//
//
//
//
//
//
//    var updatedTime = ""
    
    
    var id: Int?
    var about: String?
    var ageRange: Int?
    var birthday: String?
    var context: String?
    var cover: String?
    var currency: String?
    var devices: String?
    var education: String?
    var email: String?
    var firstName: String?
    var gender: String?
    var hometown: String?
    var installType: String?
    var isSharedLogin: Bool??
    var isVerified: Int?
    var languages: String?
    var lastName: String?
    var link: String?
    var locale: String?
    var location: String?
    var middleName: String?
    var name: String?
    var political: String?
    var relationshipStatus: String?
    var religion: String?
    var shortName: String?
    var sports: String?
    var timezone: Int?
    var updatedTime: String?
    var verified: Bool?
    var website: String?
    var work: String?
    var newMatch: Bool?
    var photoUrl: String?
    var preMatch: Bool?
    var distance: Int!
    var matchId: Int!
    var photos: [[String: AnyObject]]?
    var matchedAt: String?
    
    
    var JSON: [String: Any] {
        
        return ["Id": id,
                "About": about!,
                "AgeRange": ageRange,
                "Birthday": birthday,
                "Gender": gender,
                "FirstName": firstName,
                "LastName": lastName,
                "Email": email,
                "UpdatedTime": updatedTime,
            "Context": context,
            "Cover": cover,
            "Currency": currency,
            "Devices": devices,
            "Education": education,
            "Hometown": hometown,
            "InstallType": installType,
            "IsSharedLogin": isSharedLogin,
            "IsVerified": isVerified,
            "Languages": languages,
            "Link": link,
            "Locale": locale,
            "Location": location,
            "MiddleName": middleName,
            "Name": name,
            "Political": political,
            "RelationshipStatus": relationshipStatus,
            "Religion": religion,
            "ShortName": shortName,
            "Sports": sports,
            "Timezone": timezone,
            "Verified": verified,
            "Website": website,
            "Work": work,
            "NewMatch": newMatch,
            "PhotoUrl": photoUrl,
            "PreMatch": preMatch,
            "Distance": distance,
            "MatchId": matchId,
            "Photos": photos,
            "MatchedAt": matchedAt ]
    }
}

struct ImageRequestData {
    
    var userId = 0
    var base64String  = ""
    
    var JSON: [String: Any] {
        
        return ["UserId": userId,
                "Base64String": base64String]
    }
}*/




struct RegisterRequestData {
    var id = 0
    var about = ""
    var ageRange = 0
    var birthday = ""
    var firstName = ""
    var lastName = ""
    var email = ""
    var gender = ""
    var updatedTime = ""
  
    var JSON: [String: Any] {
        
        return ["id": id,
                "about": about,
                "ageRange": ageRange,
                "gender": gender,
                "birthday": birthday,
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "updatedTime": updatedTime]
    }
}

struct ImageRequestData {
    
    var userId = 0
    var base64String  = ""
    
    var JSON: [String: Any] {
        
        return ["UserId": userId,
                "Base64String": base64String]
    }
}
