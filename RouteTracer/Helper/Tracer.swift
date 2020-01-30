//
//  Tracer.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation

class Tracer {
    var route: Route!
    
    init(route: Route) {
        self.route = route
    }
    
    func startTracking(adding coordinate: CoordinateLocation) {
        self.route.locations.append(coordinate)
    }
    
    func endTracking() {
        
    }
}
