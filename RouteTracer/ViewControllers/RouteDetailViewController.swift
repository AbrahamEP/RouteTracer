//
//  RouteDetailViewController.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController {
    
    //MARK: - UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    
    //MARK: - Properties
    var route: Route!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    //MARK: - Setup methods
    private func setup() {
        self.setupMapView()
        self.setupInfo()
    }
    
    private func setupMapView() {
        self.mapView.delegate = self
        
        let startMarker = MapMarker(title: "Start", subtitle: "Route's start", coordinate: self.route.locations.first!.coordinate2DRepresentation)
        let endMarker = MapMarker(title: "End", subtitle: "Route's end", coordinate: self.route.locations.last!.coordinate2DRepresentation)
        self.mapView.addAnnotations([startMarker, endMarker])
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        let polylineRoute = MKPolyline(coordinates: self.route.locationsIn2DCoordinate, count: self.route.locationsIn2DCoordinate.count)
        self.mapView.addOverlay(polylineRoute)
    }
    
    private func setupInfo() {
        self.title = self.route.name
        self.timeLabel.text = self.route.timeDescription
        self.distanceLabel.text = self.route.distanceStringDescription
        
    }
    
    //MARK: - Actions
    @IBAction func shareBarButtonAction() {
        
        let myRouteString = "Hi! This is my route information!"
        let shareDistanceString = "Distance: \(self.route.distanceStringDescription)"
        let shareTimeString = "Time: \(self.route.timeDescription)"
        
        let activityVC = UIActivityViewController(activityItems: [myRouteString, shareDistanceString, shareTimeString], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        let okActionHandler: (UIAlertAction) -> Void = {
            [weak self] _ in
            guard let self = self else {return}
            TracerRealmManager.deleteRoute(self.route)
            self.navigationController?.popViewController(animated: true)
        }
        let okAction = UIAlertAction(title: "Sure, I want that", style: .destructive, handler: okActionHandler)
        let cancelAction = UIAlertAction(title: "No, I don't", style: .cancel, handler: nil)
        
        self.createAlertView("Delete route", "Are you sure you want to delete \(self.route.name)", type: .alert, actions: [okAction, cancelAction])
    }
}

extension RouteDetailViewController: MKMapViewDelegate {
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.green
            polylineRenderer.lineWidth = 8
            
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}
