//
//  LastMessage.swift
//  TrueDate
//
//  Created by Armenuhi on 2/4/18.
//  Copyright © 2018 Company. All rights reserved.
//

import UIKit
import ObjectMapper

struct LastMessage: Mappable{
    
    var messageId: Int?
    var conversationId: Int?
    var fromUser: String?
    var toUser: String?
    var message: String?
    var messageSent: String?
    
    init?(map: Map) {
        
    }

    
    mutating func mapping(map: Map) {
        self.messageId <- map["MessageId"]
        self.conversationId <- map["ConversationId"]
        self.fromUser <- map["FromUser"]
        self.toUser <- map["ToUser"]
        self.message <- map["Message"]
        self.messageSent <- map["MessageSent"]
    }
}
