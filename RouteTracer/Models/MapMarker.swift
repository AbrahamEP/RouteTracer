//
//  MapMarker.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 31/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
