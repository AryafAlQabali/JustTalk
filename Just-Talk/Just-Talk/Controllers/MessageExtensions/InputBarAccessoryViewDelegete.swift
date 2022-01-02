//
//  InputBarAccessoryViewDelegete.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import InputBarAccessoryView


extension MessageVC: InputBarAccessoryViewDelegate {
 
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        print("Typing", text)
        updateMicButStatus(show: text == "")
        
        if text != "" {
            startTypingIndicator()
        }

    }
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
      send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }



}
