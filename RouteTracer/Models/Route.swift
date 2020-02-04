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
    var distanceStringDescription: String {
        return String(format: "%.2f", self.distanceInKm) + " km"
    }
    var locationsIn2DCoordinate: [CLLocationCoordinate2D] {
        return self.locations.map { (location) -> CLLocationCoordinate2D in
            return location.coordinate2DRepresentation
        }
    }
    var timeDescription: String {
        let intervalFormatter = DateComponentsFormatter()
        intervalFormatter.allowedUnits = [.hour, .minute, .second]
        intervalFormatter.unitsStyle = .full
        
        guard let start = self.startTime, let end = self.endTime, let timeString = intervalFormatter.string(from: start, to: end) else {
            return "Not available"
        }
        return timeString
    }
    
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

