//
//  MKMessage.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import MessageKit
import CoreLocation


class MKMessage: NSObject, MessageType {
    var sentDate: Date
    
    var messageId: String
    var kind: MessageKind

    
    var mkSender: MessageKitSender
    var sender: SenderType {return mkSender}
    var senderInitials: String
    
    
    var photoItem:PhotoMSG?
    var videoItem: VideoMSG?
    var locationItem: LocationMSG?
    var audioItem : AudioMSG?
   
    
    var status: String
    var readDate: Date
    var incoming: Bool
    
    
    init(message: LocalMSG) {
        
        self.messageId = message.id
        self.mkSender = MessageKitSender(senderId: message.senderId, displayName: message.sederName)
        
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        
        
        
        
        switch message.type {
        case kTEXT:
            self.kind = MessageKind.text(message.message)

        case kPHOTO:
            let photoItem = PhotoMSG(path: message.picturUrl)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
            
            
        case kVIDEO:
            let videoItem = VideoMSG(url: nil)
            self.kind = MessageKind.video(videoItem)
            self.videoItem = videoItem


        case kLOCATION:
            let locationItem = LocationMSG(location: CLLocation(latitude: message.latitude, longitude: message.longitude))

            self.kind = MessageKind.location(locationItem)
            self.locationItem = locationItem


        case kAUDIO:
            let audioItem = AudioMSG(duration: 2.0)
            self.kind = MessageKind.audio(audioItem)
            self.audioItem = audioItem

        default:
           // self.kind = MessageKind.text(message.message)
            print ("unknow error")
        }
        
        
        self.senderInitials = message.senderinitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = User.currentId != mkSender.senderId
        
    }
    
    
    
}
