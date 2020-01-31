//
//  CoordinateLocation.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class CoordinateLocation: Object {
    @objc dynamic var id = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    var coordinate2DRepresentation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func createWith(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
