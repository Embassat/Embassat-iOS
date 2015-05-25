//
//  CADEMMapViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import MapKit

public class CADEMMapViewController: CADEMRootViewControllerSwift, MKMapViewDelegate {
    
    static let kEMMapPinIdentifier : String = "EMMapPinIdentifier"
    
    @IBOutlet weak var mapView: MKMapView?

    let viewModel: CADEMMapViewModel = CADEMMapViewModel()
    let locationManager: CLLocationManager = CLLocationManager()
    var userLocationTracked: Bool = false
    var coordinates: Array<CLLocation> {
        get {
            var coords: Array<CLLocation> = []
            
            if let annotations = mapView?.annotations as? [MKAnnotation] {
                for annotation in annotations {
                    coords.append(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
                }
            }
            
            return coords
        }
    }
    
    public override func viewDidLoad() {
        title = "Mapa"
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestWhenInUseAuthorization()
        }
        
        for var i = 0; i < viewModel.numberOfPoints(); i++
        {
            var clubAnnotation = MKPointAnnotation()
            clubAnnotation.coordinate = CLLocationCoordinate2DMake(viewModel.latitudeForPoint(atIndex: i), viewModel.longitudeForPoint(atIndex: i))
            clubAnnotation.title = viewModel.titleForPoint(atIndex: i)
            
            mapView?.addAnnotation(clubAnnotation)
        }
        
    }
    
    public func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if userLocationTracked == false &&
            userLocation.location != nil &&
            CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)) {
            userLocationTracked = true
            self.updateVisibleMapRect()
        }
    }
    
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: CADEMMapViewController.kEMMapPinIdentifier)
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    func updateVisibleMapRect() {
        mapView?.setVisibleMapRect(self.mapRect(forCoordinates: coordinates, coordCount: coordinates.count), edgePadding: UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0), animated: true)
    }
    
    func mapRect(forCoordinates coords: Array<CLLocation>, coordCount: Int) -> MKMapRect {
        var r: MKMapRect = MKMapRectNull
        
        for var i = 0; i < coordCount; i++
        {
            let location = coords[i]
            let p = MKMapPointForCoordinate(location.coordinate)
            r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0.0, 0.0))
        }
        
        return r
    }
}
