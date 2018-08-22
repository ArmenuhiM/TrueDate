//
//  User.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/21.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import ObjectMapper

struct User: Mappable{
    
    var id: Int!
    var firstName: String?
    var about: String?
    var ageRange: Int?
    var birthday: String?
    var context: String?
    var cover: String?
    var currency: String?
    var devices: String?
    var education: String?
    var email: String?
    var gender: String?
    var hometown: String?
    var installType: String?
    var isSharedLogin: Int?
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
    var verified: Int?
    var website: String?
    var work: String?
    var newMatch: Int?
    var distance: Int!
    var photoUrl: String?
    var preMatch: Bool?
    var matchId: Int!

    var photos: [[String: AnyObject]]?

    
   
    init?(map: Map) {
        
    }

    init(id: Int, name: String) {
        self.id = id
        self.firstName = name
    }
    
    mutating func mapping(map: Map) {
        self.about <- map["About"]
        self.distance <- map["Distance"]
        self.firstName <- map["FirstName"]
        self.photoUrl <- map["PhotoUrl"]
        self.preMatch <- map["PreMatch"]
        self.id <- map["Id"]
        self.ageRange <- map["AgeRange"]
        self.birthday <- map["Birthday"]
        self.context <- map["Context"]
        self.cover <- map["Cover"]
        self.currency <- map["Currency"]
        self.devices <- map["Devices"]
        self.education <- map["Education"]
        self.email <- map["Email"]
        self.gender <- map["Gender"]
        self.hometown <- map["Hometown"]
        self.installType <- map["InstallType"]
        self.isSharedLogin <- map["IsSharedLogin"]
        self.isVerified <- map["IsVerified"]
        self.languages <- map["Languages"]
        self.lastName <- map["LastName"]
        self.link <- map["Link"]
        self.locale <- map["Locale"]
        self.location <- map["Location"]
        self.middleName <- map["MiddleName"]
        self.name <- map["Name"]
        self.political <- map["Political"]
        self.relationshipStatus <- map["RelationshipStatus"]
        self.religion <- map["Religion"]
        self.shortName <- map["ShortName"]
        self.sports <- map["Sports"]
        self.timezone <- map["Timezone"]
        self.updatedTime <- map["UpdatedTime"]
        self.verified <- map["Verified"]
        self.website <- map["Website"]
        self.work <- map["Work"]
        self.newMatch <- map["NewMatch"]
        self.photos <- map["Photos"]
        self.photoUrl <- map["PhotoUrl"]
        self.preMatch <- map["PreMatch"]
        self.matchId <- map["MatchId"]
    }
}
