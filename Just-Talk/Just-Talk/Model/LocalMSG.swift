//
//  LocalMSG.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 25/05/1443 AH.
//

import Foundation
import RealmSwift

class LocalMSG : Object, Codable{

   @objc dynamic var id = ""
    @objc dynamic var chatRoomId = ""
    @objc dynamic var date = Date()
    @objc dynamic var sederName = ""
//    @objc dynamic  var sentDate = Date()
    @objc dynamic  var senderId = ""
    @objc dynamic var senderinitials = ""
    @objc dynamic  var readDate = Date()
    @objc dynamic  var type = ""
    @objc dynamic  var status = ""
    @objc dynamic  var message = ""
    @objc dynamic  var audioUrl = ""
    @objc dynamic var videoUrl = ""
    @objc dynamic var picturUrl = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var audioDuration = 0.0

    
    override class func primaryKey() -> String? {
        return "id"
    }


}
