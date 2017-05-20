//
//  MapViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: RootViewController, MKMapViewDelegate, UpdateableView {
    
    static fileprivate let kEMMapPinIdentifier = "EMMapPinIdentifier"
    static fileprivate let kDefaultEdgeInset: CGFloat = 30.0
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    
    var viewModel: MapViewModel
    var coordinates: [CLLocation] {
        get {
            return mapView.annotations.map{ CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
        }
    }
    
    required init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: MapViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mapa"
        
        locationManager.requestWhenInUseAuthorization()
        
        for i in 0..<viewModel.numberOfPoints() {
            let clubAnnotation = MKPointAnnotation()
            clubAnnotation.coordinate = CLLocationCoordinate2DMake(viewModel.latitudeForPoint(atIndex: i), viewModel.longitudeForPoint(atIndex: i))
            clubAnnotation.title = viewModel.titleForPoint(atIndex: i)
            
            mapView.addAnnotation(clubAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if  viewModel.shouldUpdateVisibleRect() &&
            CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake((userLocation.location?.coordinate.latitude)!, (userLocation.location?.coordinate.longitude)!)) {
            updateVisibleMapRect()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let annotationView: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapViewController.kEMMapPinIdentifier)
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    fileprivate func updateVisibleMapRect() {
        let inset = MapViewController.kDefaultEdgeInset
        mapView.setVisibleMapRect(mapRect(forCoordinates: coordinates, coordCount: coordinates.count), edgePadding: UIEdgeInsetsMake(inset, inset, inset, inset), animated: true)
    }
    
    fileprivate func mapRect(forCoordinates coords: [CLLocation], coordCount: Int) -> MKMapRect {
        var rect: MKMapRect = MKMapRectNull
        
        for location in coords
        {
            let point = MKMapPointForCoordinate(location.coordinate)
            rect = MKMapRectUnion(rect, MKMapRectMake(point.x, point.y, 0.0, 0.0))
        }
        
        return rect
    }
}
