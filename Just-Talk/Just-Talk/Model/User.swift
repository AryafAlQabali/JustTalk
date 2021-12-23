//
//  User.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 16/05/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Codable {
    var id = ""
    var username: String
    var email: String
    var pushld = ""
    var avatarLink = ""
    
    
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

}
func  saveUserLocally(_ user: User) {
    let ecoder = JSONEncoder()
    do {
    let data = try ecoder.encode(user)
    
        userDefaults.set(data, forKey: kCURRENTUSER)
    }catch {
        print(error.localizedDescription)
    }
}

