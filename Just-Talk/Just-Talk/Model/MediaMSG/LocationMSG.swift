//
//  LocationMSG.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 30/05/1443 AH.
//

import Foundation
import CoreLocation
import MessageKit
import UIKit


class LocationMSG: NSObject, LocationItem {
    var location: CLLocation
    var size: CGSize
    
    init (location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
    
}
