//
//  MKMessage.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import MessageKit


class MKMessage: NSObject, MessageType {
    var sentDate: Date
    
    var messageId: String
    var kind: MessageKind

    
    var mkSender: MessageKitSender
    var sender: SenderType {return mkSender}
    var senderInitials: String
   
    
    var status: String
    var readDate: Date
    var incoming: Bool
    
    
    init(message: LocalMSG) {
        
        self.messageId = message.id
        self.mkSender = MessageKitSender(senderId: message.senderId, displayName: message.sederName)
        
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        
        
        self.senderInitials = message.senderinitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = User.currentId != mkSender.senderId
        
    }
    
    
    
}
