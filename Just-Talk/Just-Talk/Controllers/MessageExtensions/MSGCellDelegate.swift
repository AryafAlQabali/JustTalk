//
//  MSGCellDelegate.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import MessageKit
import AVFoundation
import AVKit
import SKPhotoBrowser


extension MessageVC: MessageCellDelegate {
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let mkMessage = mkMessages[indexPath.section]
            if mkMessage.photoItem != nil && mkMessage.photoItem?.image != nil {

                var images = [SKPhoto]()
                let photo = SKPhoto.photoWithImage(mkMessage.photoItem!.image!)
                images.append(photo)
                
                let brower = SKPhotoBrowser(photos: images)
                present(brower, animated: true, completion: nil)
            }
            if mkMessage.videoItem != nil && mkMessage.videoItem!.url != nil {

                //Player controller
                //Player
                                
                let playerController = AVPlayerViewController()
                let player = AVPlayer(url: mkMessage.videoItem!.url!)
                playerController.player = player
                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                present(playerController, animated: true) {
                    playerController.player!.play()
                }
            }
        }
    }
    
    
    
    
}
