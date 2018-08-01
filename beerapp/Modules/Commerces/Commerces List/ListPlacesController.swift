//
//  ListPlacesController.swift
//  beerapp
//
//  Created by elaniin on 2/19/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyBeaver
import HexColors
import CoreLocation

class ListPlacesController: UIViewController, IndicatorInfoProvider, CLLocationManagerDelegate {
    

    // MARK: - Let/Var/IBOutlet
    let locationManager = CLLocationManager()
    var isLoading = true
    var commerces = [Commerce]()
    var selectedCommerce: Commerce?
    let refresh = UIRefreshControl()
    var notNear = Bool()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetDataSource = self
        
        Core.shared.registerCell(at: tableView, named: "FindShopsCell")
        
        Core.itembarbackground(controller: self, barTint: Core.hexStringToUIColor(hex: "#213363"), titleColor: Core.hexStringToUIColor(hex: "#5ABFCC"))
        
        
        refresh.addTarget(self, action: #selector(setupData), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Recargar")
        refresh.tintColor = .lightGray
        tableView.refreshControl = refresh
        
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            notNear = true
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                let params: [String: Any] = [
                    "lat": 13.7013235,
                    "lon": -89.2257943
                ]
                loadCommerces(params: params)
                notNear = true
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
                locationManager.startUpdatingLocation()
                notNear = false
            }
        } else {
            print("Location services are not enabled")
            
            let params: [String: Any] = [
                "lat": 13.7013235,
                "lon": -89.2257943
            ]
            notNear = true
            loadCommerces(params: params)
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
  
        let params: [String: Any] = [
            "lat": userLocation.coordinate.latitude.description,
            "lon": userLocation.coordinate.longitude.description
        ]
        
        print("Prueba:")
        print(params)
        loadCommerces(params: params)
        
        
  
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommercesToDetailSegue" {
            
            let detailController = segue.destination as! ShopDetailController
            detailController.commerceId = selectedCommerce?.id
            detailController.commerce = selectedCommerce
        }
    }
    
    
    
    // MAR: - Loaders/Setups
    @objc func setupData(){
        
        isLoading = true
        
        refresh.endRefreshing()
        
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Listado")
    }
    
    
    
    
    func loadCommerces(params: [String:Any]) {
        commerces.removeAll()
        tableView.reloadData()
        
        
        SwiftyBeaver.debug("Loading commerces at: \(params as! NSDictionary)")
        
        CommerceManager().nearby(params: params) {
            response in
            
            self.isLoading = false
            
            guard let commerces = response?.result else {
                SwiftyBeaver.error("No commerces")
                return
            }
            
            self.commerces = commerces
            self.tableView.reloadData()
            
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ListPlacesController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commerces.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCommerce = commerces[indexPath.row]
        performSegue(withIdentifier: "CommercesToDetailSegue", sender: self)
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FindShopsCell", for: indexPath) as? FindShopsCell else { return UITableViewCell() }
        
        cell.commerce = commerces[indexPath.row]
        if notNear == true{
            
            cell.kilometersDIstanceLabel.isHidden = true
            cell.fromLabel.isHidden = true
        }
        
        if ( indexPath.row % 2 == 0 ){
            
            cell.containerView.backgroundColor = .white
            cell.promotionsCollection.backgroundColor = .white
            cell.backgroundColor = .white
            
        }
        else{
            cell.containerView.backgroundColor = HexColor("#fafafa")
            cell.promotionsCollection.backgroundColor = HexColor("#fafafa")
            cell.backgroundColor = HexColor("#fafafa")
        }
        
        return cell
    }

}





