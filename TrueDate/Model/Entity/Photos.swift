//
//  Image.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/21.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import ObjectMapper

struct Photos: Mappable{
    
    var photoId: Int?
    var photoURL: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.photoId <- map["PhotoId"]
        self.photoURL <- map["PhotoURL"]
    }
}
