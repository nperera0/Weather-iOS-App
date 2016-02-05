//
//  LocationViewController.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-23.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    var coordinate: CLLocationCoordinate2D?
    @IBOutlet var mapView: MKMapView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let coordinate = self.coordinate else { // if coordinate is null just bail out
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region,animated: animated)
        
    }
    
    


}
