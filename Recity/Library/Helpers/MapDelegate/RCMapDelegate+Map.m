//
//  RCMapDelegate+Map.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate_Private.h"

#import "MKMapView+RCZoomLevel.h"
#import "MKMapView+More.h"
#import "RCAnnotationProject.h"
#import "RCProject.h"
#import "RCAddress.h"

@implementation RCMapDelegate (Map)

- (CGFloat)cellSizeFactorForCoordinator:(FBClusteringManager *)coordinator {
    return 2.5;
}

- (void)projectFavoriteChanged:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[RCProject class]]) {
        RCProject *project = object;
        [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isKindOfClass:[RCAnnotationProject class]]) {
                return;
            }
            RCAnnotationProject *annotation = (RCAnnotationProject *)obj;
            if ([annotation.project.uid isEqualToNumber:project.uid]) {
                [self reloadImageAnn:annotation];
            }
        }];
    } else if ([object isKindOfClass:[RCAddress class]]) {
        [self reloadVisibleAddress];
    }
}

- (void)showObject:(id)object withYDesplacement:(CGFloat)displacement
{
    if ([object isKindOfClass:[RCProject class]]) {
        [self moveMapToProject:(RCProject *)object withYDesplacement:displacement];
    } else if ([object isKindOfClass:[RCAddress class]]) {
        [self moveMapToAddress:(RCAddress *)object withYDesplacement:displacement];
    }
}

- (void)moveMapToProject:(RCProject *)project withYDesplacement:(CGFloat)displacement
{
    __block BOOL needZoom = YES;
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[RCAnnotationProject class]]) {
            return;
        }
        RCAnnotationProject *annotation = (RCAnnotationProject *)obj;
        
        if ([annotation.project.uid isEqualToNumber:project.uid]) {
            needZoom = NO;
        }
    }];
    
    CLLocationCoordinate2D coordinate = [[project centerLocation] coordinate];
    if (needZoom) {
        [self.mapView setZoomLevel:kZoomLevelMaxForProjectOverlays];
    }
    
    [self centerCoordinateIfNeeded:coordinate withYDesplacement:displacement];
}

- (void)moveMapToAddress:(RCAddress *)address withYDesplacement:(CGFloat)displacement
{
    CLLocationCoordinate2D coordinate = [address coordinate];
   
    [self.mapView setZoomLevel:kZoomLevelMaxForProjectOverlays];

    [self centerCoordinateIfNeeded:coordinate withYDesplacement:displacement];
}

- (void)centerCoordinateIfNeeded:(CLLocationCoordinate2D)coordinate withYDesplacement:(CGFloat)displacement
{
    MKMapView *map = self.mapView;
    
    CGPoint viewPoint = [map convertCoordinate:coordinate toPointToView:map];
    
    CGFloat detailsY = CGRectGetMaxY(map.frame) - displacement;
    
    if (viewPoint.y >= detailsY || !CGRectContainsPoint(map.frame, viewPoint)) {
        CLLocationCoordinate2D center = [self centerMapCoordinate:coordinate withYDesplacement:displacement];
        [map setCenterCoordinate:center animated:YES];
    }
}

- (CLLocationCoordinate2D)centerMapCoordinate:(CLLocationCoordinate2D)coordinate withYDesplacement:(CGFloat)displacement
{
    CGPoint offsetForAdd = CGPointMake(0, displacement / 2.0f);
    return [self.mapView visuallyShiftedCoordinate:coordinate onAddedPixels:offsetForAdd];;
}

@end
