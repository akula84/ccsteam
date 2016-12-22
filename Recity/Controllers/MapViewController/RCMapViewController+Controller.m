//
//  RCMapViewController+Controller.m
//  Recity
//
//  Created by Artem Kulagin on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCMapController.h"

@implementation RCMapViewController (Controller)

- (void)prepareMapController
{
    @weakify(self);
    RCMapController *controller = [RCMapController shared];
    controller.mapView = self;
    controller.didDefaultTitle = ^{
        @strongify(self);
        [self prepareDefaultTitle];
    };
    
    controller.didShowMyself = ^{
        @strongify(self);
        [self didShowMyself];
    };
    
    controller.didShowItem = ^(id item){
        @strongify(self);
        [self showItem:item];
    };
    
    controller.didUpdateNearbyProjects = ^{
        @strongify(self);
        [self updateNearbyProjects];
    };
    
    controller.saveCurrentMapSettings = ^ {
        @strongify(self);
        [self saveCurrentMapSettings];
    };
}

- (void)reloadVisibleAddress
{
    [RCMapController reloadVisibleAddress];
}

- (void)showAlert
{
    [RCMapController showAlert];
}

@end
