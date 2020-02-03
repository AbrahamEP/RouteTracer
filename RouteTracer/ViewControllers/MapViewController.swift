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
    var clearBarButton: UIBarButtonItem!
    
    //MARK: - Variables
    
    let locationManager: CLLocationManager = CLLocationManager()
    var isTracing: Bool = false
    var polylineRoute: MKPolyline!
    var tmpLocations = [CLLocationCoordinate2D]()
    var route: Route!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    //MARK: - Helper Methods
    private func setup() {
        self.setupLocationManager()
        self.setupMapView()
        self.setupBarButton()
    }
    
    private func setupBarButton() {
        self.clearBarButton = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(clearBarButtonAction))
        self.navigationItem.rightBarButtonItem = self.clearBarButton
    }
    
    private func setupMapView() {
        self.mapView.delegate = self
        self.mapView.userTrackingMode = .followWithHeading
    }
    
    private func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    private func setMarkerOnMap(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
        let marker = MapMarker(title: title, subtitle: subtitle, coordinate: coordinate)
        self.mapView.addAnnotation(marker)
    }
    
    private func clean() {
        self.tmpLocations.removeAll(keepingCapacity: false)
        self.route = nil
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        self.polylineRoute = nil
    }
    
    //MARK: - Actions
    @IBAction func traceRouteButtonAction(_ sender: UIButton) {
        if self.isTracing {
            //Stop the trace and save the route
            self.isTracing = false
            
            //Get location
            guard let coordinate = self.locationManager.location?.coordinate else {return}
            self.setMarkerOnMap(title: "End", subtitle: "Route's end", coordinate: coordinate)
            
            //End time for route
            self.route.endTime = Date()
            
            //Configure Alert
            let textFieldConfiguration: (UITextField) -> Void = {
                (textField) in
                textField.placeholder = "Here the route's name"
            }
            let alertCompletion: (UIAlertController.TextInputResult) -> Void = {
                [weak self] (result) in
                guard let self = self else {return}
                
                switch result {
                case .cancel:
                    
                    self.clean()
                    
                case .ok(let text):
                    
                    self.route.name = text
                    
                    
                    //Save the route
                    TracerRealmManager.saveRoute(self.route)
                }
            }
            
            
            
            //Ask the user the name of the route
            let alert = UIAlertController(
                title: "Route name",
                message: "Choose a name for this route",
                cancelButtonTitle: "Cancel",
                okButtonTitle: "Submit",
                validate: .nonEmpty,
                textFieldConfiguration: textFieldConfiguration,
                onCompletion: alertCompletion)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        } else {
            
            //Start the route trace
            
            //Create the route
            guard let coordinate = self.locationManager.location?.coordinate else {
                self.showAlertOneButtonWith(alertTitle: "Couldn't get the current location", alertMessage: "Try again please", buttonTitle: "Ok")
                return
            }
            self.isTracing = true
            self.route = Route()
            self.route.startTime = Date()
            
            //Set the marker on the map
            self.setMarkerOnMap(title: "Start", subtitle: "Route's start",coordinate: coordinate)
            
        } //End else
        
        
        
    }//End IBAction
    
    @objc func clearBarButtonAction() {
        guard !self.isTracing else {
            self.showAlertOneButtonWith(alertTitle: "Forbidden", alertMessage: "You can't clean the screen if you're in the middle of a trace", buttonTitle: "Ok")
            return
        }
        self.clean()
    }
     
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {
            return
        }
        
        if self.isTracing {
            //Start tracing route
            
            self.route.locations.append(userLocation.coordinate.toCoordinateLocation())
            self.tmpLocations.append(userLocation.coordinate)
            self.polylineRoute = MKPolyline(coordinates: self.tmpLocations, count: self.tmpLocations.count)
            self.mapView.addOverlay(self.polylineRoute)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 8
            
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
        guard let annotation = annotation as? MapMarker else { return nil }
          
        let identifier = "marker"
        var view: MKMarkerAnnotationView
          
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        view.displayPriority = .required
        return view
    }
}
