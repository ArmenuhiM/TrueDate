//
//  Message.swift
//  Tindest
//
//  Created by TakuSemba on 2017/01/26.
//  Copyright © 2017年 TakuSemba. All rights reserved.
//

import UIKit
import ObjectMapper

struct Conversation: Mappable {
        
    var conversationId: Int?
    var otherUser: OtherUser?
    var dateTimeCreated: String?
    var fromReadDate: String?
    var toReadDate: String?
    var newMailAlert: Bool?
    var lastMessage: LastMessage?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.conversationId <- map["ConversationId"]
        self.otherUser <- map["OtherUser"]
        self.dateTimeCreated <- map["DateTimeCreated"]
        self.fromReadDate <- map["FromReadDate"]
        self.toReadDate <- map["ToReadDate"]
        self.newMailAlert <- map["NewMailAlert"]
        self.lastMessage <- map["LastMessage"]

    }
}
