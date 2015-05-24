//
//  CADEMMapViewController.m
//  Embassat
//
//  Created by Joan Romano on 14/04/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMMapViewController.h"

#import "CADEMMapViewModel.h"

#import <MapKit/MapKit.h>

static NSString *const kEMMapPinIdentifier = @"EMMapPinIdentifier";

@interface CADEMMapViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, copy) NSArray *coordinates;
@property (nonatomic) BOOL userLocationTracked;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CADEMMapViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"Mapa";
    }
    
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    for (int i = 0; i < [self.viewModel nunmberOfPoints]; i++)
    {
        MKPointAnnotation *clubAnnotation = [[MKPointAnnotation alloc] init];
        
        clubAnnotation.coordinate = CLLocationCoordinate2DMake([self.viewModel latitudeForPointAtIndex:i], [self.viewModel longitudeForPointAtIndex:i]);
        clubAnnotation.title = [self.viewModel titleForPointAtIndex:i];
        
        [self.mapView addAnnotation:clubAnnotation];
    }
}

#pragma mark - MKMapView Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.userLocationTracked &&
        userLocation.location &&
        CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)))
    {
        self.userLocationTracked = YES;
        [self updateVisibleMapRect];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kEMMapPinIdentifier];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

#pragma mark - Private

- (void)updateVisibleMapRect
{
    [self.mapView setVisibleMapRect:mapRectForCoordinates(self.coordinates, [self.coordinates count]) edgePadding:UIEdgeInsetsMake(30.0f, 30.0f, 30.0f, 30.0f) animated:YES];
}

- (NSArray *)coordinates
{
    NSMutableArray *coords = [@[] mutableCopy];
    
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
        if (![annotation isKindOfClass:[MKUserLocation class]])
        {
            [coords addObject:[[CLLocation alloc] initWithLatitude:[annotation coordinate].latitude longitude:[annotation coordinate].longitude]];
        }
    }];
    
    _coordinates = [coords copy];
    
    return _coordinates;
}

MKMapRect mapRectForCoordinates(NSArray *coords, NSUInteger coordCount) {
    MKMapRect r = MKMapRectNull;
    for (NSUInteger i = 0; i < coordCount; ++i)
    {
        CLLocation *location = coords[i];
        MKMapPoint p = MKMapPointForCoordinate(location.coordinate);
        r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
    }
    
    return r;
}

@end
