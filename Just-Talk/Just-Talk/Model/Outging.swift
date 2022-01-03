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
            sendPhoto(message: message, photo: photo!, memberIds: memberIds)
        }
        
        if video != nil {
            sendVideo(message: message, video: video!, memberIds: memberIds)
            
        }
        
        if location != nil {
            sendLocation(message: message, memberIds: memberIds)
        }
        
        if audio != nil {
            sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
    
            
            
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





func sendPhoto(message: LocalMSG, photo: UIImage, memberIds: [String]) {
    message.message = "Photo Message"
    message.type = kPHOTO
    
    
    let fileName = Date().stringDate()
    let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"


    FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)

    FileStorage.uploadeImage(photo, directory: fileDirectory) { (imageURL) in

        if imageURL != nil {
            message.picturUrl = imageURL!
        Outgoing.saveMessage(message: message, memberIds: memberIds)//
            }
        }
    }


func sendVideo(message: LocalMSG, video: Video, memberIds:[String]) {
    message.message = "Video Message"
    message.type = kVIDEO
    
    
    let fileName = Date().stringDate()
    
    let thumbnailDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    let videoDirectory = "MediaMessages/Video/" + "\(message.chatRoomId)" + "_\(fileName)" + ".mov"

    let editor = VideoEditor()
    
    editor.process(video: video) { (processedVideo, videoUrl) in
        
        if let tempPath = videoUrl {
            
            let thumbnail = videoThumbnail(videoURL: tempPath)
            
            FileStorage.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7)! as NSData, fileName: fileName)
            FileStorage.uploadeImage(thumbnail, directory: thumbnailDirectory) { (imageLink) in
                
                if imageLink != nil {
                    let videoData = NSData(contentsOfFile: tempPath.path)
                    
                    FileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                    
                    FileStorage.uploadeImage(videoData!, directory: videoDirectory) { (videoLink) in
                        
                        message.videoUrl = videoLink ?? ""
                        message.picturUrl = imageLink ?? ""
                        
                        Outgoing.saveMessage(message: message, memberIds: memberIds)


                        
                    }
                }
            }
        }
    }
}

func sendLocation(message: LocalMSG, memberIds: [String]) {
    
    let currentLocation = LocationManager.shared.currentLocation
    
    message.message = "Location Message"
    message.type = kLOCATION
    message.latitude = currentLocation?.latitude ?? 0.0
    message.longitude = currentLocation?.longitude ?? 0.0
  
        Outgoing.saveMessage(message: message, memberIds: memberIds)
    }


func sendAudio(message: LocalMSG, audioFileName: String, audioDuration: Float, memberIds: [String]) {
   
    message.message = "Audio Message"
    message.type = kAUDIO
    let fileDirectory = "MediaMessages/Audio/" + "\(message.chatRoomId)" + "_\(audioFileName)" + ".m4a"
    
    FileStorage.uploadAudio(audioFileName, directory: fileDirectory) { (audioLink) in
        
        if audioLink != nil {
            
            message.audioUrl = audioLink ?? ""
            message.audioDuration = Double(audioDuration)
                  Outgoing.saveMessage(message: message, memberIds: memberIds)
            
        }
        
    }

    
}
    

