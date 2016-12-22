//
//  RCMapDelegate.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 19.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@import MapKit;

NS_ASSUME_NONNULL_BEGIN

@class RCProject,RCAddress;

@interface RCMapDelegate : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (void)showProjects:(NSArray <RCProject *> *)projects;
- (void)updateImagesOfVisibleAnnotations;
- (void)deSelectCurrentItem;
- (void)prepareMapCenterCoordinateWithCurrentLocation:(nullable CLLocation *)currentLocation;

@property (strong ,nonatomic, readonly) RCMapSettings *currentMapSettings;

@end

@interface RCMapDelegate (Address)

- (void)showAddress:(RCAddress *)address;
- (void)reloadVisibleAddress;
- (void)deSelectCurrentAddress;

@end

@interface RCMapDelegate (Select)

- (void)selectProject:(RCProject *)project;
- (void)deSelectCurrentProject;

@end

NS_ASSUME_NONNULL_END
