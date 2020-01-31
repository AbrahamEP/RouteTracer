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
    @objc dynamic var id = 0
    @objc dynamic var locations: [CoordinateLocation] = []
    @objc dynamic var name: String = ""
    @objc dynamic var startPoint: CoordinateLocation?
    @objc dynamic var endPoint: CoordinateLocation?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func createWith(name: String, startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, locations: [CLLocationCoordinate2D]) {
        self.name = name
        self.startPoint = CoordinateLocation()
        self.startPoint?.createWith(coordinate: startPoint)
        self.endPoint = CoordinateLocation()
        self.endPoint?.createWith(coordinate: endPoint)
        
        self.locations = locations.map { (coordinate) -> CoordinateLocation in
            let location = CoordinateLocation()
            location.createWith(coordinate: coordinate)
            return location
        }
    }
    
    func createWith(name: String, startPoint: CoordinateLocation, endPoint: CoordinateLocation, locations: [CoordinateLocation]) {
        self.name = name
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

extension Route {
    
}
