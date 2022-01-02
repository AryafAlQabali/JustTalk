//
//  MSGDisplayDelegate.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import UIKit
import MessageKit


extension MessageVC: MessagesDisplayDelegate {
    
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return .label
        
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorOutgoing = UIColor(named: "ColorOutgoingBubble")
        let bubbleColorIncoming = UIColor(named: "ColorincomingMessageBubble")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing as! UIColor : bubbleColorIncoming as! UIColor
        
        
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .pointedEdge)
        
        
    }

}
