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
    let refereshController = UIRefreshControl()
    let micBut = InputBarButtonItem()
    
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
configureMSGCollectionView()
        configureMessageInputBar()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

    private func configureMSGCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refereshController
        
    }
    
    private func configureMessageInputBar() {
        messageInputBar.delegate = self
        
        let attachBut = InputBarButtonItem()
        attachBut.image = UIImage(systemName: "plus.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        attachBut.setSize(CGSize(width: 30, height: 30), animated: false)
        attachBut.onTouchUpInside { item in
            print("Attaching")

            //TODO:- Attach action
        }
        
//        let micBut = InputBarButtonItem()
        micBut.image = UIImage(systemName: "mic.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micBut.setSize(CGSize(width: 30, height: 30), animated: false)
        
        
        //Add gesture recognizer
        messageInputBar.setStackViewItems([attachBut], forStack: .left, animated: false)
        
        messageInputBar.setStackViewItems([attachBut], forStack: .left, animated: false)
        
        //TODO:- Update mic But status
        updateMicButStatus(show: true)
        
        
        
        
        //تمنع المستخدم ليقوم ب بيست لل امج داخل المسج لل فيو
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    
        
        
        
    }
    func updateMicButStatus (show: Bool) {
        if show {
            messageInputBar.setStackViewItems([micBut], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
}
