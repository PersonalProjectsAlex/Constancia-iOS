//
//  FindPlacesViewControllerExtensionViewController.swift
//  beerapp
//
//  Created by elaniin on 1/29/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SwiftyBeaver
import MapKit

extension FindPlacesController: MKMapViewDelegate {
    
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            
        }
    }
    
    @objc func connected(_ sender:AnyObject){
        
        
        let storyboard = UIStoryboard(name: "FIndPlaces", bundle: nil)
        let shopDetailControllerID = storyboard.instantiateViewController(withIdentifier: "ShopDetailControllerID") as! ShopDetailController
        for i in commerces{
            print("IDDD::" + i.id!)
            if i.id == self.savetag{
                print("IDDD::" + self.savetag)
                
                shopDetailControllerID.commerce = i
                shopDetailControllerID.commerceId = i.id
                SwiftyBeaver.warning(i.id)
            }
        }

        SwiftyBeaver.warning(self.ss.count)
        present(shopDetailControllerID, animated: true , completion: nil)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        
        if annotation is MKUserLocation { return nil }
        var annotationView = self.placesMapkit.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil{
            
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else{ annotationView?.annotation = annotation }
        annotationView?.image = UIImage(named: "icon-places-pin")
        
        return annotationView
        
        
    }
    
    
    
    func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view: UIView? = placesMapkit?.subviews.first
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        for recognizer: UIGestureRecognizer in (view?.gestureRecognizers)! {
            if recognizer.state == .began || recognizer.state == .ended {
                return true
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if mapChangedFromUserInteraction {
            print(mapChangedFromUserInteraction)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if mapChangedFromUserInteraction {
            print(mapView.region)
            
            
            self.getNearbyPlacess(lat: mapView.region.center.latitude, lon: mapView.region.center.longitude)
            
        }
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        
        let reuseId = "Pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
            
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
            let droppedAt = view.annotation?.coordinate
            
        }
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        // 1
        
        // Don't proceed with custom calloutz
        if view.annotation is MKUserLocation { return }
        
        // 2
        let placeAnnotation = view.annotation as! PlacesAnnotations
        
        
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        
        calloutView.iconShopsImageView.image = placeAnnotation.logo
        
        
        if self.placesMapkit.selectedAnnotations.count > 0 {
            
            self.savetag = placeAnnotation.tag.description
            
            
            SwiftyBeaver.warning("selectedid:" + placeAnnotation.id.description)
            
            for i in commerces{
                if let promotion = i.promotions, i.id == savetag{
                    calloutView.typeImageView.image = promotion.count > 0 ? #imageLiteral(resourceName: "ubication_promo") : #imageLiteral(resourceName: "ubication_restaurant")
                }
            }
        }
        
        
        
        let button = UIButton(frame: calloutView.iconShopsImageView.frame)
        
        button.addTarget(self, action: #selector(self.connected(_:)), for: .touchUpInside)
        calloutView.addSubview(button)
        
        // 3
        //        calloutView.center = CGPoint(x: view.bounds.size.width, y: -calloutView.bounds.size.height*0.46)
        calloutView.center = CGPoint(x: 0, y: -calloutView.bounds.size.height / 2)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    
    

    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        
        if view.isKind(of: AnnotationView.self) {
        
            
            for subview in view.subviews {
                //subview.removeFromSuperview()
            }
        }
    }
    
    
    
}

