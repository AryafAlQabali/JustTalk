//
//  FusserListener.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 16/05/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift




class FUserListener {
    
    static let shared = FUserListener()
    
    private init(){}
    
    
    //MARK:- Login
    func loginUserWith(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool)-> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResults, error) in
            
            if error == nil && authResults!.user.isEmailVerified {
                completion(error, true)
                self.downloadUserFromFirestore(userId: authResults!.user.uid)
                
            } else {
                completion(error, false)
            }
            
        }
        
    
    }
    
    //MARK:- Logout
    func logoutCurrentUser(completion: @escaping (_ error: Error?)-> Void){
       
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
        } catch let erroe as NSError {
                completion(erroe)
            }
    
    }
    
    
    
    
    
    
    
    
    //MARK:- Register
    
    func registerUserWith (email: String, password: String, completion: @escaping(_ error: Error?) -> Void ) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] (authResults, error) in
            completion(error)
            
            if error == nil {
                authResults! .user.sendEmailVerification { (error) in
                    
                   completion(error)
                }
            }
            if authResults?.user != nil {
                let user = User(id: authResults!.user.uid, username: email, email: email, pushld: "", avatarLink: "", status: " Hi!".localized)
                
                
                
                saveUserToFirestore(user)
              saveUserLocally(user)
                
                
        }
    }
}
    //MARK:- Resend link verficiation function
    
    func resendVerficationEmailWith(email: String, completion: @escaping (_ erroe: Error?)->Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                completion(error)
            })
        })
    }
    
    
    
    //MARK:- Reset Password
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?)-> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    
    
    
    
    
    
     func saveUserToFirestore (_ user: User) {
        
        do {
           try FirestoreReference(.User).document(user.id).setData(from: user)
        }catch{
            print(error.localizedDescription)
    }
    
    
    
    
    
    
}
    
    
    //MARK:- Downlaod user from firestor
    private func downloadUserFromFirestore(userId: String) {
        
        FirestoreReference(.User).document(userId).getDocument { (document, error) in
            
            guard let userDocument = document else {
                print("No data found")
            return
        }
            let result = Result {
            
   try? userDocument.data (as: User.self)
    }
            switch result {
            case.success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                }else{
                    print("Document does not exist")
                }
            case.failure(let error):
                print("error decoding", error.localizedDescription)
            
            }
}
}
    //MARK:- Download users using IDs
    
    func downloadUsersFromFirestor(withIds: [String], completion: @escaping(_ allUsers: [User])-> Void) {
        
        var count = 0
        var usersArray: [User] = []
        
        for userId in withIds {
            
            FirestoreReference(.User).document(userId).getDocument { (querySnapshot, error) in
                
                guard let document = querySnapshot else {
                     return
                }
                let user = try? document.data(as: User.self)
                usersArray.append (user!)
                count+=1
                
                if count == withIds.count {
                    completion (usersArray)
                }
            }
        }
        
    }
    
    
    
    
    
    
    //MARK:- Download all users
    func downloadAllUsersFoemFirestore(completion: @escaping (_ allUsers: [User])-> Void) {
        var users: [User] = []
        
        FirestoreReference(.User).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print(" No document found")
                return
            }
            let allUsers = documents.compactMap { (snapshot) -> User? in
                return try? snapshot.data(as: User.self)
            }
            for user in allUsers {
                if User.currentId != user.id {
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    
    
    
    
    
}
