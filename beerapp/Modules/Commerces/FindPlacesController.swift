//
//  FindPlacesViewController.swift
//  beerapp
//
//  Created by elaniin on 1/29/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyBeaver
import XLPagerTabStrip
import CoreLocation
import UserNotifications
import Presentr


class FindPlacesController: UIViewController, IndicatorInfoProvider, CLLocationManagerDelegate {
    
    // MARK: - Let/Var/IBOutlet
    let locationManager = CLLocationManager()
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    var savetag = String()
    var ss = [Int]()
    var states: Bool?
    
    var commerces = [Commerce]()
    var promotions = [Promotion]()
    var mapChangedFromUserInteraction = false
    public var long = String()
    public var lat = String()

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var placesMapkit: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUP()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        // If location services is enabled get the users location
        
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                settingMap(lat: 13.7013235, lon: -89.2257943)
                
                getNearbyPlacess(lat: 13.7013235, lon: -89.2257943)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            
            settingMap(lat: 13.7013235, lon: -89.2257943)
            
            getNearbyPlacess(lat: 13.7013235, lon: -89.2257943)
            
            
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        locationManager.startUpdatingLocation()
        
        manager.stopUpdatingLocation()
        manager.stopMonitoringSignificantLocationChanges()
        manager.delegate = nil
        
        
        settingMap(lat: userLocation.coordinate.latitude, lon:userLocation.coordinate.longitude)
        
        let params: [String: Any] = [
            "lat": userLocation.coordinate.latitude.description,
            "lon": userLocation.coordinate.longitude.description
        ]
        
        
        self.activityIndicator.startAnimating()
        CommerceManager().nearby(params: params) { (places) in
            

                guard let commerces = places?.result else {
                    SwiftyBeaver.error("No commerces")
                    return
                }
                
                self.getAnnotations(array: commerces)
                self.commerces = commerces
                SwiftyBeaver.error("No commerces")

            if let firstCommerce = commerces.first{
                
                if let lat = firstCommerce.lat?.toDouble(), let lon = firstCommerce.lon?.toDouble(), let distance = firstCommerce.distance?.toDouble(){
                    let location1 = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                    
                    let location2 = CLLocation(latitude: lat, longitude: lon)
                    
                    let getdistance : CLLocationDistance = location1.distance(from: location2)
                    
                    print("distance = \(getdistance) m")
                    
                    if getdistance <= distance{
                        self.showNearestCommerce(commerce: firstCommerce)
                    }
                    
                }
            }
            
                
            
        }
        
        
        
        
        
        
    }
    
    
    
    func getNearbyPlacess(lat: Double, lon: Double){
        let params: [String: Any] = [
            "lat": lat,
            "lon": lon
        ]
        
        
        CommerceManager().nearby(params: params) { (places) in
            
            if places?.status == "true" && places?.result != nil{
                guard let commerces = places?.result else {
                    SwiftyBeaver.error("No commerces")
                    
                    return
                }
                
                self.getAnnotations(array: commerces)
                self.commerces = commerces
                SwiftyBeaver.error("No commerces")
               
                
                
            }else{
                
                
            }
            
        }
    }
    
    func settingMap(lat: Double, lon: Double){
        let span = MKCoordinateSpanMake(0.02,0.02)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: lat, longitude: lon), span)
        self.placesMapkit.setRegion(region, animated: true)
    }
    
    func getAnnotations(array:[Commerce]){
        
        
        for  i in array{
            
            guard let lat = i.lat, let lon = i.lon, let id = i.id, let logo = i.logo else{
                print("Error")
                return
            }
            
            guard let latdouble = lat.toDouble(), let lonDouble = lon.toDouble() else{
                print("Error")
                return
            }
            
            let location = PlacesAnnotations(coordinate: CLLocationCoordinate2D(latitude: latdouble, longitude: lonDouble ))
            
            
            Core.shared.getDataFromUrl(url: URL(string:logo)!, completion: { (data, response, error) in
                
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    if data.description != ""{
                        location.logo = UIImage(data: data)
                        
                    }else{
                        location.logo = UIImage(named: "example")
                    }
                }
            })
            
            location.tag = Int(id)
            location.id = id
            
            
            self.placesMapkit.addAnnotation(location)
            
        }
    }
    
    
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.crossDissolve
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    
    lazy var nearestCommerceController: NearestCommerceController = {
        
        let popupViewController = UIStoryboard(name: "FIndPlaces", bundle: nil).instantiateViewController(withIdentifier: "NearestCommerceControllerID") as! NearestCommerceController
        
        return popupViewController
    }()
    
    
    func showNearestCommerce(commerce:Commerce){

 
        
            presenter.presentationType =  .popup
            presenter.transitionType = .crossDissolve
            presenter.dismissTransitionType = nil
            presenter.dismissOnSwipe = false
            
            nearestCommerceController.commerce = commerce
            customPresentViewController(presenter, viewController: nearestCommerceController, animated: true, completion: nil)
        
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Mapa")
    }
    
    
    func setUP() {
        Core.shared.setIndiciatorToLeft(controller: self, activityIndicator: activityIndicator)
        // Ask for Authorisation from the User.
        
        
        //Mapkit
        placesMapkit.showsUserLocation = true
        placesMapkit.isZoomEnabled = true
        placesMapkit.showsTraffic = true
        placesMapkit.mapType = .standard
        placesMapkit.showsBuildings = true
        placesMapkit.showsPointsOfInterest = true
        
    }
    
    
    
}



