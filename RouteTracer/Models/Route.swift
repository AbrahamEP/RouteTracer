//
//  Route.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class Route: Object {
    
    var locations = List<CoordinateLocation>()
    @objc dynamic var name: String = ""
    @objc dynamic var startTime: Date?
    @objc dynamic var endTime: Date?
    @objc dynamic var distanceInKm: Double = 0.0
    
    func createWith(name: String,  locations: [CLLocationCoordinate2D], startTime: Date, endTime: Date, distanceKm: Double) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.distanceInKm = distanceKm
        
        for location in locations {
            self.locations.append(location.toCoordinateLocation())
        }
    }
    
    func createWith(name: String, locations: List<CoordinateLocation>, startTime: Date, endTime: Date, distanceKm: Double) {
        self.name = name
        self.locations = locations
        self.startTime = startTime
        self.endTime = endTime
        self.distanceInKm = distanceKm
    }
}

extension Route {
    
}
