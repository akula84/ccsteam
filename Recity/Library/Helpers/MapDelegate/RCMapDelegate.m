//
//  RCMapDelegate.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 19.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate.h"
#import "RCMapDelegate_Private.h"

#import "RCAnnotationProject.h"
#import "RCProject.h"
#import "MKMapView+RCZoomLevel.h"
#import "RCMapController.h"
#import "RCMapSettings.h"

@interface RCMapDelegate () 

@property (assign, nonatomic) MKMapRect mapRect;

@end

@implementation RCMapDelegate

- (instancetype)init
{
    if(self = [super init]) {
        self.currentMapSettings = [AppState loadMapSettings];
    }
    return self;
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView.delegate = nil;
    _mapView = (id)mapView;
    [self configureOverlay];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectFavoriteChanged:) name:kProjectFavoriteChangedNotification object:nil];
     [self prepareMapController];
}

- (void)prepareMapCenterCoordinateWithCurrentLocation:(CLLocation *)currentLocation
{
    MKMapView *mapView = _mapView;
    
    CLLocationCoordinate2D mapCenterCoordinate;
    NSUInteger mapZoomLevel = kZoomLevelMaxForProjectOverlays;
    
    if(currentLocation) {
        mapCenterCoordinate = currentLocation.coordinate;
    } else {
        RCMapSettings *mapSettings = self.currentMapSettings;
        mapCenterCoordinate = mapSettings.centerCoordinate;
        mapZoomLevel = mapSettings.zoomLevel;
    }
    
    [mapView setCenterCoordinate:mapCenterCoordinate
                       zoomLevel:mapZoomLevel
                        animated:NO];
}

- (void)prepareMapController
{
    @weakify(self);
    RCMapController *controller = [RCMapController shared];
    controller.didReloadVisibleAddress = ^{
        @strongify(self);
        [self reloadVisibleAddress];
    };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateImagesOfVisibleAnnotations
{
    NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:[self mapRectIncrease]];
    for (RCAnnotationProject *annotation in visibleAnnotations) {
        if ([annotation isKindOfClass:[RCAnnotationProject class]]) {
            [self reloadImageAnn:annotation];
        }
    }
}

- (NSMutableArray <id<MKOverlay>> *)projectOverlays
{
    if (_projectOverlays != nil) {
        return _projectOverlays;
    }
    
    _projectOverlays = [NSMutableArray array];
    
    return _projectOverlays;
}

- (void)showProjects:(NSArray <RCProject *> *)projects
{
    [self setAnnotationsForProjects:projects];
    [self addOverlaysForProjects:projects];
    [self hideOverlaysIfNeeded];
}

- (MKMapRect)mapRectIncrease
{
    MKMapRect rect = self.mapView.visibleMapRect;
    double width = MKMapRectGetWidth(rect);
    double height = MKMapRectGetHeight(rect);
    return MKMapRectInset(rect, - width, -height);
}

- (void)deSelectCurrentItem
{
    [self deSelectCurrentProject];
    [self deSelectCurrentAddress];
}

@end
