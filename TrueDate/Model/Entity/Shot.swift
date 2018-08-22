//
//  Shot.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/21.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import ObjectMapper

struct Shot: Mappable{
    
    var preMatch: Bool?
    var distance: Int?
    var user: User?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.preMatch <- map["PreMatch"]
        self.distance <- map["Distance"]
        self.user <- map["User"]
    }
}



