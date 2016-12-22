//
//  RCMapController.h
//  Recity
//
//  Created by Artem Kulagin on 29.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

@import MapKit;

@class RCProject,RCAddress,RCMapViewController, RCMapSettings;

@interface RCMapController : NSObject

@property (strong, nonatomic) id selectedItem;
@property (weak, nonatomic) RCMapViewController *mapView;

@property (copy, nonatomic) void(^didDefaultTitle)(void);
@property (copy, nonatomic) void(^didShowMyself)(void);
@property (copy, nonatomic) void(^didReloadVisibleAddress)(void);
@property (copy, nonatomic) void(^didShowItem)(id item);
@property (copy, nonatomic) void(^didUpdateNearbyProjects)();
@property (copy, nonatomic) void(^saveCurrentMapSettings)();

+ (void)prepareDefaultTitle;
+ (void)showMyLocation;

+ (void)showIndexFromMyLocation:(CLLocation *)location;

+ (void)showItem:(id)item;
+ (void)reloadVisibleAddress;

+ (RCProject *)selectedProject;
+ (RCAddress *)selectedAddress;
+ (void)selectedClear;

+ (void)updateNearbyProjects;
+ (void)showAlert;

+ (DidPressedProjectImageBlock)didPressedProjectImageBlock;
+ (void)close;
+ (UINavigationController *)currentNav;

@end
