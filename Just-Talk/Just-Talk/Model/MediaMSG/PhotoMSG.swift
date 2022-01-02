//
//  PhotoMSG.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 29/05/1443 AH.
//

import Foundation
import MessageKit
import UIKit


class PhotoMSG : NSObject, MediaItem {
    var url : URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init (path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
        
    }
    
}
