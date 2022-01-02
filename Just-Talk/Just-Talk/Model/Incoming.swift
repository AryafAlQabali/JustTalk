//
//  Incoming.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 28/05/1443 AH.
//


import Foundation
import MessageKit
import CoreLocation

class Incoming {
    
    var messageViewController: MessagesViewController
    
    init (messageViewController: MessagesViewController) {
        
        self.messageViewController = messageViewController
    }
    
    func createMKMessage (LocalMSG: LocalMSG) -> MKMessage {
        
        let mkMessage = MKMessage(message: LocalMSG)
         return mkMessage
    }
}
