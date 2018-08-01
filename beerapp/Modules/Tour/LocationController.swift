//
//  LocationController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    // MARK: - Actions
    
    @IBAction func allowLocation(_ sender: UIButton) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationEnabled = CLLocationManager.locationServicesEnabled()
        let authStatus = CLLocationManager.authorizationStatus()
        
        guard locationEnabled, authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse else {
            
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.startUpdatingLocation()
        
        self.performSegue(withIdentifier: "LocationToNotificationSegue", sender: self)
        
    }
    
    @IBAction func allowLater(_ sender: UIButton) {
        performSegue(withIdentifier: "LocationToNotificationSegue", sender: self)
    }
    
}

extension LocationController: CLLocationManagerDelegate {
    
    // didChangeAuthorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            self.performSegue(withIdentifier: "LocationToNotificationSegue", sender: self)
        }
    }
}
