//
//  MapAnnotation.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 30/05/1443 AH.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init (title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
