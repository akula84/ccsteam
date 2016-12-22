//
//  RCFloatViewSliderController.m
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewSliderController.h"

@implementation RCFloatViewSliderController
SINGLETON_OBJECT

+ (void)setNoDetectTableView:(UITableView *)tableView
{
    RUN_BLOCK([self controller].didNoDetectTableView,tableView);
}

+ (void)displayFullscreen
{
    RUN_BLOCK([self controller].didDisplayFullscreen);
}

+ (void)displayFullscreenIfHalf:(dispatch_block_t)complete
{
    RUN_BLOCK([self controller].didDisplayFullscreenIfHalf,complete)
}

+ (void)displayHalfscreen
{
    RUN_BLOCK([self controller].didDisplayHalfscreen);
}

+ (void)displayHalfscreenIfFull:(dispatch_block_t)complete
{
    RUN_BLOCK([self controller].didDisplayHalfscreenIfFull,complete)
}

+ (void)prepareToolbarFromStateNormal:(NSInteger)toolbarViewItemIndex selectedItemPressed:(BOOL)selectedItemPressed
{
    RUN_BLOCK([self controller].didPrepareToolbarFromStateNormal,toolbarViewItemIndex,selectedItemPressed)
}

+ (RCFloatViewSliderController *)controller
{
    return [RCFloatViewSliderController shared];
}

+ (void)hideMenuCompletion:(dispatch_block_t)completion1 andDisplayProjectDetailsAnimatedCompletion:(dispatch_block_t)completion2
{
     RUN_BLOCK([self controller].didHideMenuCompletion,completion1,completion2)
}

+ (BOOL)isDisplayedFull
{
    BOOL result = NO;
    if([self controller].isDisplayedFull) {
        result = [self controller].isDisplayedFull();
    }
    return result;}

+ (void)updateNearbyProjectsIfNeed
{
    RUN_BLOCK([self controller].didUpdateNearbyProjectsIfNeed);
}

+ (BOOL)isScrollViewMoved
{
    BOOL result = NO;
    if([self controller].isScrollViewMoved) {
        result = [self controller].isScrollViewMoved();
    }
    return result;
}

@end
