//
//  MapViewController.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var traceRouteButton: UIButton!
    
    //MARK: - Variables
    
    let locationManager: CLLocationManager = CLLocationManager()
    var startPoint: MKPointAnnotation?
    var endPoint: MKPointAnnotation?
    var isTracing: Bool = false
    var isFirstTimeLocation = true
    var polylineRoute: MKPolyline!
    var route: Route!
    var locations: [CLLocationCoordinate2D] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    //MARK: - Helper Methods
    private func setup() {
        self.setupLocationManager()
        self.setupMapView()
    }
    
    private func setupMapView() {
        self.mapView.delegate = self
        self.mapView.userTrackingMode = .follow
    }
    
    private func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK: - Actions
    @IBAction func traceRouteButtonAction(_ sender: UIButton) {
        if self.isTracing {
            //Stop trace and save the route
            self.endPoint = MKPointAnnotation()
            self.endPoint!.title = "End"
            self.endPoint!.coordinate = self.locationManager.location!.coordinate
            self.mapView.addAnnotation(self.endPoint!)
            self.isTracing = false
            
        } else {
            //Start trace
            //Set point annotation
            self.startPoint = MKPointAnnotation()
            self.startPoint!.title = "Start"
            self.startPoint!.coordinate = self.locationManager.location!.coordinate
            self.mapView.addAnnotation(self.startPoint!)
            self.isTracing = true
            
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {
            return
        }
        
        if self.isTracing {
            //Start tracing route
            self.locations.append(userLocation.coordinate)
            self.polylineRoute = MKPolyline(coordinates: self.locations, count: self.locations.count)
            self.mapView.addOverlay(self.polylineRoute)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 4
            
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        return nil
    }
}
