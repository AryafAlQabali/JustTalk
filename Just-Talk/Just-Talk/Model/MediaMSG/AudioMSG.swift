//
//  AudioMSG.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 30/05/1443 AH.
//

import Foundation
import MessageKit
import UIKit


class AudioMSG: NSObject, AudioItem {
    
    var url : URL
    var duration: Float
    var size: CGSize
    
    init(duration: Float) {
        
        self.url = URL(fileURLWithPath: "")
        self.size = CGSize(width: 180, height: 35)
        
        self.duration = duration
    }
}
