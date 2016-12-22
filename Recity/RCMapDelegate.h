//
//  RCMapDelegate.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 19.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@class RCProject;

typedef void (^RCMapDelegateBlock)(id mapDelegate, MKMapView *);
typedef void (^RCMapDelegateProjectBlock)(id mapDelegate, RCProject *);
@interface RCMapDelegate : NSObject

@property (copy, nonatomic) RCMapDelegateBlock didZoom;
@property (copy, nonatomic) RCMapDelegateBlock didMove;
@property (copy, nonatomic) RCMapDelegateProjectBlock didSelectProject;

- (instancetype)init NS_UNAVAILABLE;
- (void)showProjects:(NSArray <RCProject *> *)projects;
- (void)displayOverlayForProject:(RCProject *)project;

- (void)updateImagesOfAllDisplayedAnnotations;

@end
