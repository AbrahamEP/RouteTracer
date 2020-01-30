//
//  Route.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation
import CoreLocation

struct Route: Codable {
    var locations: [CoordinateLocation] = []
    var name: String
    var startPoint: CoordinateLocation
    var endPoint: CoordinateLocation
}
