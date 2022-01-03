//
//  Incoming.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 28/05/1443 AH.
//


import Foundation
import MessageKit
import CoreLocation
import UIKit


class Incoming {
    
    var messageViewController: MessagesViewController
    
    init (messageViewController: MessagesViewController) {
        
        self.messageViewController = messageViewController
    }
    
    func createMKMessage (LocalMSG: LocalMSG) -> MKMessage {
        
        let mkMessage = MKMessage(message: LocalMSG)
         
    
      
    if LocalMSG.type == kPHOTO {
        
        let photoItem = PhotoMSG(path: LocalMSG.picturUrl)
        mkMessage.photoItem = photoItem
        mkMessage.kind = MessageKind.photo(photoItem)
        
        FileStorage.downloadImage(imageUrl: LocalMSG.picturUrl) { (image) in
            
            mkMessage.photoItem?.image = image
            
            self.messageViewController.messagesCollectionView.reloadData()
        }
    }
        
        
        
        
        if LocalMSG.type == kVIDEO {
            FileStorage.downloadImage(imageUrl: LocalMSG.picturUrl) { (thumbnail) in
                FileStorage.downloadVideo(videoUrl: LocalMSG.videoUrl) { (readyToPlay, fileName) in
                    
                    let videoLink = URL (fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))
                    let videoItem = VideoMSG(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    
                    mkMessage.videoItem?.image = thumbnail
                    self.messageViewController.messagesCollectionView.reloadData()
                    
                }
            }
        }
        
        if LocalMSG.type == kLOCATION {
            
            let locationItem = LocationMSG(location: CLLocation(latitude: LocalMSG.latitude, longitude: LocalMSG.longitude))
            
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        
        }
        
        if LocalMSG.type == kAUDIO {
            
            let audioMessage = AudioMSG(duration: Float(LocalMSG.audioDuration))
            
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)

            FileStorage.downloadAudio(audioUrl: LocalMSG.audioUrl) { (fileName) in
                
                let audioURL = URL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))

                mkMessage.audioItem?.url = audioURL
                
                
                
                
            }
            self.messageViewController.messagesCollectionView.reloadData()
            
            
        }
        
        return mkMessage
    
    
}
}
