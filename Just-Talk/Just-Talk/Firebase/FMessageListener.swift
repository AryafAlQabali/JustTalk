//
//  FMessageListener.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FMessageListener {
     static let shared = FMessageListener()
    
    var newMSGListener : ListenerRegistration!
    var updatedMessageListener : ListenerRegistration!

    
    private init () {}
    func addMessage (_ message: LocalMSG, memberId: String){
        
        do {
 try FirestoreReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("error saving message to firestore", error.localizedDescription)
        }
       
    }
    
     //MARK:- check for old message
    
    
    func checkForOldMessage(_ documentId: String, collectionId: String) {
        
        FirestoreReference(.Message).document(documentId).collection(collectionId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else { return}
            
            var oldMessages = documents.compactMap { (querySnapshot) -> LocalMSG? in
                
                return try? querySnapshot.data(as: LocalMSG.self)
            }
            
            oldMessages.sort(by: {$0.date < $1.date})
            
            for message in oldMessages {
                RealmManager.shared.save(message)
            }
            
        }
        
    }
    
    func listenForNewMessages(_ documentId: String, collectionId: String, lastMessageDate: Date) {
        
        newMSGListener = FirestoreReference(.Message).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else {return}
            
            for change in snapshot.documentChanges {
                
                if change.type == .added {
                    
                    let result = Result {
                        try? change.document.data(as: LocalMSG.self)
                        
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            if message.senderId != User.currentId {
                                RealmManager.shared.save(message)
                            }
                        }
                                                
                    case .failure(let error):
                        print (error.localizedDescription)
                    
                    }
                    
                }
            }
            
        })
    
    }
    
    //MARK:- Update message status
   
   func updateMessageStatus (_ message: LocalMSG, userId: String) {
       
       let values = [kSTATUS: kREAD, kREADDATE: Date()] as [String: Any]
       
       FirestoreReference(.Message).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
       
   }
    
     //MARK:- Listen for Read status update
    
    func listenForReadStatus (_ documentId: String, collectionId: String, completion:@escaping(_ updatedMessage: LocalMSG)->Void) {
        
        updatedMessageListener = FirestoreReference(.Message).document(documentId).collection(collectionId).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else {return}
            
            for change in snapshot.documentChanges {
                if change.type == .modified {
                    
                    let result = Result {
                        try? change.document.data(as: LocalMSG.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            completion (message)
                        }

                    case .failure(let error):
                        print ("Error decoding", error.localizedDescription)
                    }
                    
                }
            }
            
            
        })
        
        
    }

        
        func removeNewMessageListener() {
            self.newMSGListener.remove()
            self.updatedMessageListener.remove()
        }
    

}
