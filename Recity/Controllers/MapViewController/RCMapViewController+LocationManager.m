//
//  RCMapViewController+LocationManager.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCMapDelegate.h"
#import "MKMapView+RCZoomLevel.h"
#import "RCMapController.h"

@implementation RCMapViewController (LocationManager)

- (void)prepareLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDistanceFilter:100.0];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [self prepareMapCenterCoordinate];
}

- (void)prepareMapCenterCoordinate
{
    [self.mapDelegate prepareMapCenterCoordinateWithCurrentLocation:self.locationManager.location];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.timerLocation = [NSTimer scheduledTimerWithTimeInterval:60.f target:self selector:@selector(turnOnLocationManager)  userInfo:nil repeats:NO];
}

- (void)turnOnLocationManager
{
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self showRequestAuthorizationLocation];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didShowMyself
{
    [self turnOnLocationManager];
    MKUserLocation *userLocation = self.mapView.userLocation;
    CLLocation *location = userLocation.location;
    if (location == nil) {
        return;
    }
    [self.mapView setCenterCoordinate:userLocation.coordinate zoomLevel:16 animated:YES];
    
    [RCMapController showIndexFromMyLocation:location];
    
    [[RCAnalyticsServicesComposite sharedInstance] trackEventWithCategory:RCMapCategory
                                                                   action:RCMapShowMySelfAction
                                                                    label:@"User on map"
                                                                    value:nil];
}

- (void)showRequestAuthorizationLocation
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Services Disabled"
                                                                             message:@"Please enable Location Services in device settings to enable this feature"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                     }];
    UIAlertAction *back = [UIAlertAction actionWithTitle:@"Back"
                                                   style:UIAlertActionStyleDefault
                                                 handler:nil];
    [alertController addAction:back];
    [alertController addAction:settings];
    
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:nil];
}

@end
