//
//  UserModel.swift
//  TrueDate
//
//  Created by Armenuhi on 9/16/17.
//  Copyright © 2017 Company. All rights reserved.
//


import Foundation
import RealmSwift

class UserModel: Object {
    dynamic var id = 0
    dynamic var about = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var email = ""
    dynamic var agerange = 0
    dynamic var birthday = ""
    dynamic var updatedtime = ""
    dynamic var gender = ""
    dynamic var currentUser = false
  
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: [String: Any]) {
        self.init()
        self.id = json["Id"] as? Int ?? 0
        self.about = json["About"] as? String ?? ""
        self.firstName = json["FirstName"] as? String ?? ""
        self.lastName = json["LastName"] as? String ?? ""
        self.email = json["Email"] as? String ?? ""
        self.agerange = json["AgeRange"] as? Int ?? 0
        self.birthday = json["Birthday"] as? String ?? ""
        self.gender = json["Gender"] as? String ?? ""
        self.updatedtime = json["UpdatedTime"] as? String ?? ""
    }
}
