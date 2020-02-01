//
//  Tracer.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import Foundation
import RealmSwift

let myRealm = try! Realm()

class TracerRealmManager {
    static func saveRoute(_ route: Route) {
        try! myRealm.write {
            myRealm.add(route)
        }
    }
    
    static func deleteRoute(_ route: Route) {
        try! myRealm.write {
            myRealm.delete(route)
        }
    }
    
    static func updateObject(configuration: () -> Void) {
        try! myRealm.write {
            configuration()
        }
    }
}
