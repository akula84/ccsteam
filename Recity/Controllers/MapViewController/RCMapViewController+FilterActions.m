//
//  RCMapViewController+FilterActions.m
//  Recity
//
//  Created by Vitaliy Zhukov on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCFilterManager.h"
#import "RCBaseNavigationController.h"
#import "RCFiltersTableViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation RCMapViewController (FilterActions)

- (void)setupFilterButtonGestures
{
    BOOL hasForceTouch = [self.view.traitCollection forceTouchCapability] == UIForceTouchCapabilityAvailable;
    
    if (hasForceTouch) {
        DFContinuousForceTouchGestureRecognizer *recognizer = [[DFContinuousForceTouchGestureRecognizer alloc] init];
        recognizer.forceTouchDelegate = self;
        [self.filterButton addGestureRecognizer:recognizer];
    } else {
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouchRecognized:)];
        [self.filterButton addGestureRecognizer:recognizer];
    }
}

- (void)longTouchRecognized:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self switchFilters];
    }
}

- (void)forceTouchRecognized:(DFContinuousForceTouchGestureRecognizer *)recognizer
{
    [self switchFilters];
}

- (void)switchFilters
{
    RCFilterManager *manager = [RCFilterManager shared];
    if ([manager isCurrentConfigDefault]) {
        [self showFiltersAction:nil];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        manager.filteringEnabled = !manager.isFilteringEnabled;
        [self reloadProjects];
    }
}

- (IBAction)showFiltersAction:(id)sender
{
    RCFiltersTableViewController *filtersVC = [RCFiltersTableViewController instantiateFromStoryboardNamed:@"Filters"];
    filtersVC.mapController = self;
    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    [nav slideLayerInDirection:direction_top andPush:filtersVC];
}

@end
