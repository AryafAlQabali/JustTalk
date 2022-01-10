//
//  User.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 16/05/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift



struct User: Codable , Equatable {
    var id = ""
    var username: String
    var email: String
    var pushld = ""
    var avatarLink = ""
    var status: String
    
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    
    static var currentUser: User? {
        
        
        if Auth.auth().currentUser != nil {
            if let data = userDefaults.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(User.self, from: data)
    
                    return userObject
                }catch{
                    
                    print(error.localizedDescription)
                }
            }
        
    }
    return nil
}

    static func == (lift: User, right: User)-> Bool {
        lift.id == right.id
    }
    
    
    
    
    
    
}
func  saveUserLocally(_ user: User) {
    let ecoder = JSONEncoder()
    //swift ---> jeson
    do {
    let data = try ecoder.encode(user)
    
        userDefaults.set(data, forKey: kCURRENTUSER)
    }catch {
        print(error.localizedDescription)
    }
    
    
}
//    func createdummyusers() {
//        print("creating dummy users...")
//
//        let names = ["Arya","Jood","Hind", "Hadeel", "Ahlam"]
//
//        var imageIndex = 1
//        var userIndex = 1
//
//        for i in 0..<5 {
//
//            let id = UUID().uuidString
//            let fileDirctory = "Avatars/" + "_\(id)" + ".jpg"
//
//            FileStorage.uploadeImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirctory) {
//                (avatarLink) in
//
//                let user = User(id: id, username: names[i], email:"user\(userIndex)@mail.com", pushld: "", avatarLink: avatarLink ?? "", status: "No Status")
//
//                userIndex += 1
//                FUserListener.shared.saveUserToFirestore(user)
//            }
//            imageIndex += 1
//            if imageIndex == 5 {
//                imageIndex = 1
//            }
//        }
//    }


