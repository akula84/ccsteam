//
//  RCMapViewController+MapView.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"
#import "RCMapDelegate_Private.h"

#import "RCFloatViewSlider.h"
#import "RCProject.h"
#import "RCAddress.h"

@implementation RCMapViewController (MapView)

- (void)displayProjectOnMapWithUpdateDetailsVC:(RCProject *)project
{
    [self addProjectToHistory:project];
    
    [self displayProjectOnMap:project];
}

- (void)displayProjectOnMapAndAddToRecent:(RCProject *)project
{
    [self displayProjectOnMap:project];
    
    [self addRecentItem:project];
}

- (void)displayProjectOnMap:(RCProject *)project
{
    if (!project) {return;}
    [self.mapDelegate showObject:project withYDesplacement:self.floatViewSlider.detailsHalfDisplayedFloatViewHeight];
    [self.mapDelegate selectProject:project];
    
    
    [[RCAnalyticsServicesComposite sharedInstance] trackEventWithCategory:RCDevelopmentDetailsCategory
                                                                   action:RCDevelopmentDetailsSelectAction
                                                                    label:project.name
                                                                    value:nil];
}

- (void)showAddress:(RCAddress *)address
{
    if (address.address.isFull) {
        [self addRecentItem:address];
    }
    
    [self displayAddressOnMap:address];
    [self addAddressToHistory:address];
}

- (void)displayAddressOnMap:(RCAddress *)address
{
    [self.mapDelegate showObject:address withYDesplacement:self.floatViewSlider.detailsHalfDisplayedFloatViewHeight];
    [self.mapDelegate showAddress:address];
    
    [[RCAnalyticsServicesComposite sharedInstance] trackEventWithCategory:RCDevelopmentIndexCategory
                                                                   action:RCDevelopmentIndexSelectAction
                                                                    label:address.address
                                                                    value:nil];
}

@end
