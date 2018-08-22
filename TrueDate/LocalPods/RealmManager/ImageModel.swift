//
//  ImageModel.swift
//  TrueDate
//
//  Created by Armenuhi on 9/17/17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import RealmSwift

class ImageModel: Object {
    
    dynamic var id = 0
    dynamic var PhotoURL = ""
    dynamic var PhotoId = 0

    
    override class func primaryKey() -> String? {
        return "id"
    }
   
    convenience init(json: [String: Any]) {
        self.init()
        self.id = json["id"] as? Int ?? 0
        self.PhotoURL = json["PhotoURL"] as? String ?? ""
        self.PhotoId = json["PhotoId"] as? Int ?? 0
    }
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
