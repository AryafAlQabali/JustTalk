//
//  RealmManager.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 26/05/1443 AH.
//

import Foundation
import RealmSwift

class  RealmManager {
    
    static let shared = RealmManager ()
    
    let realm = try! Realm()
    
    private init () {}
    
    func save<T: Object> (_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("error saving data", error.localizedDescription)
        }
    }
}
