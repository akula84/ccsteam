//
//  RCMapViewController+Gesture.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCSearchManager.h"
#import "RCColoredPolygon.h"
#import "RCFloatViewSlider.h"

@implementation RCMapViewController (Gesture)

- (void)addTapGesture
{
    UINavigationBar *navigationBar = [self navigationBar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [navigationBar addGestureRecognizer:tap];
    self.tapNav = tap;
}

- (void)removeTapGesture
{
    UINavigationBar *navigationBar = [self navigationBar];
    [navigationBar removeGestureRecognizer:self.tapNav];
}

- (void)actionTap:(id)sender
{
    NSString *title = self.title;
    if (![title isEqualToString:defaultBarTitle] ) {
        [RCSearchManager shared].searchText = title;
    }
    [self checkPossibleSearch];
}

//http://stackoverflow.com/questions/20858108/detecting-touches-on-mkoverlay-in-ios7-mkoverlayrenderer
- (void)setupMapOverlayTaps
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    tap2.cancelsTouchesInView = NO;
    tap2.numberOfTapsRequired = 2;
    
    [self.mapView addGestureRecognizer:tap2];
    [self.mapView addGestureRecognizer:tap];
    [tap requireGestureRecognizerToFail:tap2]; // Ignore single tap if the user actually double taps
}

-(void)handleMapTap:(UIGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [tap locationInView:self.mapView];
        
        CLLocationCoordinate2D tapCoord = [self.mapView convertPoint:tapPoint toCoordinateFromView:self.mapView];
        MKMapPoint mapPoint = MKMapPointForCoordinate(tapCoord);
        CGPoint mapPointAsCGP = CGPointMake((CGFloat)mapPoint.x, (CGFloat)mapPoint.y);
        
        for (id<MKOverlay> overlay in self.mapView.overlays) {
            if([overlay isKindOfClass:[MKPolygon class]]){
                RCColoredPolygon *polygon = (RCColoredPolygon *)overlay;
                
                CGMutablePathRef mpr = CGPathCreateMutable();
                
                MKMapPoint *polygonPoints = polygon.points;
                
                for (NSUInteger p = 0; p < polygon.pointCount; p++){
                    MKMapPoint mp = polygonPoints[p];
                    if (p == 0)
                        CGPathMoveToPoint(mpr, NULL, (CGFloat)mp.x, (CGFloat)mp.y);
                    else
                        CGPathAddLineToPoint(mpr, NULL, (CGFloat)mp.x, (CGFloat)mp.y);
                }
                
                if(CGPathContainsPoint(mpr , NULL, mapPointAsCGP, FALSE)){
                     [self displayProjectOnMapWithUpdateDetailsVC:polygon.project];
                    CGPathRelease(mpr);
                    return;
                }
                CGPathRelease(mpr);
            }
        }
        [self.floatViewSlider hideFloatViewAnimatedCompletion:^{}];
    }
}

@end
