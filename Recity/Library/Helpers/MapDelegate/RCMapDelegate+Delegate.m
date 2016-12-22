//
//  RCMapDelegate+Delegate.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate_Private.h"

#import "RCColoredPolygon.h"
#import "RCPolygonRenderer.h"
#import "MKMapView+RCZoomLevel.h"
#import "RCAnnotationProject.h"
#import "RCClusterAnnotationView.h"
#import "RCAnnotationAddress.h"
#import "RCMapController.h"
#import "RCFloatViewSliderController.h"

@implementation RCMapDelegate (Delegate)

-(MKOverlayRenderer *)mapView:(MKMapView*)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[RCColoredPolygon class]]) {
        RCPolygonRenderer *lineView = (RCPolygonRenderer *)[mapView rendererForOverlay:overlay];
        if (!lineView) {
            lineView = [[RCPolygonRenderer alloc] initWithOverlay:overlay];
        }
        
        [lineView update];

        return lineView;
    }
    return [[MKTileOverlayRenderer alloc] initWithOverlay:overlay];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.regionWasBelowMaxZoomLevel = mapView.zoomLevel < kZoomLevelMaxForProjectOverlays;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self displayAnnotations];
    [RCFloatViewSliderController updateNearbyProjectsIfNeed];
    
    [self.currentMapSettings setNewCenterCoordinate:self.mapView.centerCoordinate
                                       newZoomLevel:self.mapView.zoomLevel];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLocation.title = @"";
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKAnnotationView *view;
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        view = [self clusterView:annotation];
    }else{
        view = [self pinView:annotation];
    }
    [self pinViewaddTempGesture:view];
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    id<MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        [RCMapController showMyLocation];
    }
}

- (RCClusterAnnotationView *)clusterView:(id<MKAnnotation>)annotation
{
    NSString *reuseIdentifier = @"cluster";
    RCClusterAnnotationView *clusterView = (RCClusterAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!clusterView) {
        clusterView = [[RCClusterAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIdentifier];
        clusterView.canShowCallout = NO;
    }
    clusterView.annotation = annotation;
    [clusterView setCount:[(FBAnnotationCluster *)annotation annotations].count];
    return clusterView;
}

- (MKAnnotationView *)pinView:(id<MKAnnotation>)annotation
{
    NSString *reuseIdentifier = @"Annotation";
    MKAnnotationView *pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:reuseIdentifier];
        pinView.canShowCallout = NO;
    }
    else {
        pinView.annotation = annotation;
    }
    [pinView setImage:[(id <RCAnnotationProtocol>)annotation image]];
    
    if ([annotation isKindOfClass:[RCAnnotationAddress class]]){
        pinView.layer.zPosition = 1;
    }
    return pinView;
}

- (void)pinViewaddTempGesture:(MKAnnotationView *)pinView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinButtonTap:)];
    tap.numberOfTapsRequired = 1;
    [pinView addGestureRecognizer:tap];
}

- (void)handlePinButtonTap:(UITapGestureRecognizer *)gestureRecognizer
{
    MKAnnotationView *pinView = (MKAnnotationView *)gestureRecognizer.view;
    id <MKAnnotation> annotation = pinView.annotation;
    
    if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        [self.mapView setCenterCoordinate:annotation.coordinate zoomLevel:self.mapView.zoomLevel + 1 animated:YES];
        return;
    }
    
    id item;
    if ([annotation isKindOfClass:[RCAnnotationProject class]]){
        item = ((RCAnnotationProject *)annotation).project;
    } else if ([annotation isKindOfClass:[RCAnnotationAddress class]]){
        item = ((RCAnnotationAddress *)annotation).address;
    }
    [RCMapController showItem:item];
}

@end
