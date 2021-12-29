//
//  MessageVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 25/05/1443 AH.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class MessageVC: MessagesViewController {
    
    //MARK:- Vars
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    //MARK:- init
    init(chatId: String, recipientId: String, recipientName: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
