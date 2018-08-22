//
//  Messages.swift
//  TrueDate
//
//  Created by Armenuhi on 1/29/18.
//  Copyright © 2018 Company. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class Messages: NSObject, JSQMessageData {
    var text_: String
    var senderId_: String
    var date_: Date
    var senderDisplayName_: String
    var isMediaMessage_: Bool
    var imageUrl_: String?
    
    convenience init(text: String?, senderId: String?, senderDisplayName: String?, date: Date?, isMediaMessage: Bool) {
        self.init(text: text, senderId: senderId, senderDisplayName: senderDisplayName, date: date, isMediaMessage: isMediaMessage)
    }
    
    init(text: String?, senderId: String?, senderDisplayName: String?, date: Date?, isMediaMessage: Bool, imageUrl: String?) {
        self.text_ = text!
        self.senderId_ = senderId!
        self.date_ = date!
        self.senderDisplayName_ = senderDisplayName!
        self.isMediaMessage_ = isMediaMessage
        self.imageUrl_ = imageUrl
    }
    

    func text() -> String{
        return text_
    }

    func senderId() -> String {
        return senderId_
    }

    func date() -> Date {
        return date_ as Date
    }

    func senderDisplayName() -> String {
        return senderDisplayName_
    }

    func isMediaMessage() -> Bool {
        return isMediaMessage_
    }

    func messageHash() -> UInt {
        return UInt(self.hash)
    }
    
    func imageUrl() -> String? {
        return imageUrl_
    }
}

