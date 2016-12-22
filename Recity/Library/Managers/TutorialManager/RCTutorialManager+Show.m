//
//  RCTutorialManager+Show.m
//  Recity
//
//  Created by Artem Kulagin on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTutorialManager_Private.h"

#import "RCTutorialContainerViewController.h"
#import "RCMapController.h"

@implementation RCTutorialManager (Show)

+ (void)beginTutorialIfNeeded
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *tutorialKey = @"recity.tutorial";
    if (![settings objectForKey:tutorialKey]) {
        [self beginTutorial];
        [settings setObject:@YES forKey:tutorialKey];
        [settings synchronize];
    }
}

+ (void)beginTutorial
{
    
    [RCTutorialManager projectForCurrentCity];
    
    [[RCTutorialManager shared] saveState];
    
    RCTutorialContainerViewController *tutorial = [RCTutorialContainerViewController instantiateFromStoryboardNamed:@"Tutorial"];
    tutorial.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    tutorial.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[RCMapController currentNav] presentViewController:tutorial animated:YES completion:nil];
}

@end
