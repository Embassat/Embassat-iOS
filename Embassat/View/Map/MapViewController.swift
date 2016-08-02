//
//  MapViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: EmbassatRootViewController, MKMapViewDelegate, UpdateableView {
    
    static private let kEMMapPinIdentifier = "EMMapPinIdentifier"
    static private let kDefaultEdgeInset: CGFloat = 30.0
    
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
        
        super.init(nibName: String(MapViewController), bundle: nil)
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
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if  viewModel.shouldUpdateVisibleRect() &&
            CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake((userLocation.location?.coordinate.latitude)!, (userLocation.location?.coordinate.longitude)!)) {
            updateVisibleMapRect()
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let annotationView: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: MapViewController.kEMMapPinIdentifier)
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    private func updateVisibleMapRect() {
        let inset = MapViewController.kDefaultEdgeInset
        mapView.setVisibleMapRect(mapRect(forCoordinates: coordinates, coordCount: coordinates.count), edgePadding: UIEdgeInsetsMake(inset, inset, inset, inset), animated: true)
    }
    
    private func mapRect(forCoordinates coords: [CLLocation], coordCount: Int) -> MKMapRect {
        var rect: MKMapRect = MKMapRectNull
        
        for location in coords
        {
            let point = MKMapPointForCoordinate(location.coordinate)
            rect = MKMapRectUnion(rect, MKMapRectMake(point.x, point.y, 0.0, 0.0))
        }
        
        return rect
    }
}
