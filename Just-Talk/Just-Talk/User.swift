//
//  User.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 16/05/1443 AH.
//

import Foundation
import FirebaseFirestoreSwift


struct User: Codable {
    var id = ""
    var username: String
    var email: String
    var pushld = ""
    var avatarLink = ""
    
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
