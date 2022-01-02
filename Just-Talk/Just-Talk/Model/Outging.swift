//
//  Outging.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 28/05/1443 AH.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import Gallery

class Outgoing {
    
    class func sendMessage(chatId: String, text: String?, photo: UIImage?, video: Video?, audio: String?, audioDuration: Float = 0.0, location: String?, memberIds: [String]) {
        
        //1. Create local message from the data we have
        
        let currentUser = User.currentUser!
        
        let message = LocalMSG()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.sederName = currentUser.username
        message.senderinitials = String (currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        
        //2. Check message type
        if text != nil {
            sendText(message: message, text: text!, memberIds: memberIds)
        }
        
        if photo != nil {
//            sendPhoto(message: message, photo: photo!, memberIds: memberIds)
        }
        
        if video != nil {
//            sendVideo(message: message, video: video!, memberIds: memberIds)
            
        }
        
        if location != nil {
//            sendLocation(message: message, memberIds: memberIds)
        }
        
        if audio != nil {
//            sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
        //3. Save message locally
        //4. Save message to firestore
    }
        FChatRoomListener.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.message)
        
        
    }
    class func saveMessage (message:LocalMSG, memberIds:[String]) {
        
        RealmManager.shared.save(message)
        
        for memberId in memberIds {
            FMessageListener.shared.addMessage(message, memberId: memberId)
            
        }
    }
    
}
    func sendText(message: LocalMSG, text: String, memberIds: [String]) {
        message.message = text
        message.type = kTEXT
        Outgoing.saveMessage(message: message, memberIds: memberIds)
    }



