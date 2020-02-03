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
    }
    
    private func setupMapView() {
        
    }
    
    //MARK: - Actions
    @IBAction func shareBarButtonAction() {
        
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        
    }
}
