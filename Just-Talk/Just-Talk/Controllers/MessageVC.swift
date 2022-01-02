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
import Foundation

class MessageVC: MessagesViewController {
    
    //MARK:- View customized
   
   let leftBarButtonView: UIView = {
       return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
   }()
   
   
   let titleLabel: UILabel = {
       let title = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 25))
       title.textAlignment = .left
       title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
       title.adjustsFontSizeToFitWidth = true
       
       return title
       
   }()
   
   let subTitleLabel: UILabel = {
      let title = UILabel(frame: CGRect(x: 5, y: 22, width: 100, height: 24))
       title.font = UIFont.systemFont(ofSize: 13, weight: .medium)
       title.adjustsFontSizeToFitWidth = true
       title.textAlignment = .left
       return title
   }()
    
   
 
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    let refereshController = UIRefreshControl()
    let micBut = InputBarButtonItem()
    
    let currentUser = MessageKitSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    var mkMessages : [MKMessage] = []
    var allLocalMSG: Results<LocalMSG>!
    let realm = try! Realm()
    
    var notifcationToken : NotificationToken?
    
    var dispayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var typingCounter = 0
    
    
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
       // self.title = recipientName
        
        loadMessages()
        listenForNewMessages()
        
        
        configureCustomTitle()
        createTypingObsever()
        
        listenForReadStatusUpdates()
        
        
        // Do any additional setup after loading the view.
        
        navigationItem.largeTitleDisplayMode = .never
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
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        //TODO:- Update mic But status
        updateMicButStatus(show: true)
        
        
        
        
        //تمنع المستخدم ليقوم ب بيست لل امج داخل المسج لل فيو
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    
        
        
        
    }
    
    
    
    
     //MARK:- configure custom title
    
    private func configureCustomTitle() {
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left.2"), style: .plain, target: self, action: #selector(self.backButtonPresseed))]
        
        
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
        
        titleLabel.text = self.recipientName

        
    }
    
    
    
    @objc func backButtonPresseed() {
        
        removeListeners()
        FChatRoomListener.shared.clearUnreadCounterUnsingChatRoomId(chatRoomId: chatId)
        self.navigationController?.popViewController(animated: true)

    }
    
    //MARK:- MarkMessageAs read
   
   private func markMessageAsRead(_ localMSG: LocalMSG) {
       if localMSG.senderId != User.currentId {
           FMessageListener.shared.updateMessageStatus(localMSG, userId: recipientId)
           
       }
       
   }
    
    
    
    //MARK:- Update typing indicator
   
   func updateTypingIndicator(_ show: Bool) {
       
       subTitleLabel.text = show ? "Typing..." : ""
   
   }
    
    func startTypingIndicator() {
        
        typingCounter += 1
        FTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.stopTypingIndicator()
        }
        
        
    }
    
    
    func stopTypingIndicator() {
         typingCounter -= 1
        
        if typingCounter == 0 {
            FTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
        }
        
    }
    
    func createTypingObsever() {
        FTypingListener.shared.createTypingObserver(chatRoomId: chatId) { (isTyping) in
            
            DispatchQueue.main.async {
                self.updateTypingIndicator(isTyping)
            }
            
            
        }
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
    
    
    
    func send(text: String?, photo: UIImage?, video: Video?, audio: String?, location: String?, audioDuration: Float = 0.0) {
        
        Outgoing.sendMessage(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId, recipientId])
        
    
}
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refereshController.isRefreshing {
            
            if dispayingMessagesCount < allLocalMSG.count {
                
                self.insertMoreMKMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
                
            }
        }
        
        refereshController.endRefreshing()

    }

    
    //MARK:- Load Messages
   
   private func loadMessages() {
       
       let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
       
       allLocalMSG = realm.objects(LocalMSG.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
       
       if allLocalMSG.isEmpty {
       checkForOldMessage()
       }
       

       notifcationToken = allLocalMSG.observe({(change: RealmCollectionChange) in
           
           switch change {
           
           case .initial:
               self.insertMKMessages()
               self.messagesCollectionView.reloadData()
               self.messagesCollectionView.scrollToLastItem(animated: true)
               
           case .update(_, _, let insertions, _):
               for index in insertions {
                   self.insertMKMessage(LocalMSG: self.allLocalMSG[index])
                   self.messagesCollectionView.reloadData()
                   self.messagesCollectionView.scrollToLastItem(animated: false)
                   self.messagesCollectionView.scrollToBottom(animated: false)

               }
               
               
           case .error(let error):
               print("error on new insertion",error.localizedDescription)
           }
       })



   }
    
    
    
    private func insertMKMessage(LocalMSG: LocalMSG) {
        markMessageAsRead(LocalMSG)
//        markMessageAsRead(LocalMSG)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(LocalMSG: LocalMSG)
        self.mkMessages.append(mkMessage)
        dispayingMessagesCount += 1
}
    private func insertOlderMKMessage(LocalMSG: LocalMSG) {
//        markMessageAsRead(LocalMSG)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(LocalMSG: LocalMSG)
        self.mkMessages.insert(mkMessage, at: 0)
        dispayingMessagesCount += 1
}
    
    private func insertMKMessages() {
        
        
        maxMessageNumber = allLocalMSG.count - dispayingMessagesCount
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        
        for i in minMessageNumber ..< maxMessageNumber {
            insertMKMessage(LocalMSG: allLocalMSG[i])
        }
    }
    
    
    private func insertMoreMKMessages() {
        
        
        maxMessageNumber = minMessageNumber - 1
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            insertOlderMKMessage(LocalMSG: allLocalMSG[i])
        }
    }
    
    
    private func checkForOldMessage() {
        
        FMessageListener.shared.checkForOldMessage(User.currentId, collectionId: chatId)
    }
    private func listenForNewMessages() {
        FMessageListener.shared.listenForNewMessages(User.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    
    
    
    //MARK:- Update Read Status
   
   private func updateReadStatus (_ updatedLocalMSG: LocalMSG){
       
       for index in 0 ..< mkMessages.count {
           
           let tempMessage = mkMessages[index]
           if updatedLocalMSG.id == tempMessage.messageId {
               mkMessages[index].status = updatedLocalMSG.status
               mkMessages[index].readDate = updatedLocalMSG.readDate
               
               RealmManager.shared.save(updatedLocalMSG)
               
               if mkMessages[index].status == kREAD {
                   self.messagesCollectionView.reloadData()
               }
       
           }
       }
       
   }
    private func listenForReadStatusUpdates() {
        
        FMessageListener.shared.listenForReadStatus(User.currentId, collectionId: chatId) { (updatedMessage) in
            
            self.updateReadStatus(updatedMessage)
            
        }
    }
    
    
    
     //MARK:- Helpers
    
    private func lastMessageDate()-> Date {
        
        let lastMessageDate = allLocalMSG.last?.date ?? Date()
        
        return Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
    }

    
  private func removeListeners() {
        FTypingListener.shared.removeTypingListener()
         FMessageListener.shared.removeNewMessageListener()
        
        
    }
    
    
}
