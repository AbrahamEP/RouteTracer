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
    @objc dynamic var startPoint: CoordinateLocation?
    @objc dynamic var endPoint: CoordinateLocation?
    
    func createWith(name: String, startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, locations: [CLLocationCoordinate2D]) {
        self.name = name
        self.startPoint = startPoint.toCoordinateLocation()
        self.endPoint = endPoint.toCoordinateLocation()
        for location in locations {
            self.locations.append(location.toCoordinateLocation())
        }
    }
    
    func createWith(name: String, startPoint: CoordinateLocation, endPoint: CoordinateLocation, locations: List<CoordinateLocation>) {
        self.name = name
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

extension Route {
    
}
