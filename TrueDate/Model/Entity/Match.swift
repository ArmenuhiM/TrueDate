//
//  Shot.swift
//  Tindest
//
//  Created by TakuSemba on 2016/12/21.
//  Copyright © 2016年 TakuSemba. All rights reserved.
//

import UIKit
import ObjectMapper

struct Match: Mappable{
    
    var match: Int?
    var user: User?
    var matchedAt: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.match <- map["MatchId"]
        self.user <- map["User"]
        self.matchedAt <- map["MatchedAt"]
    }
}



