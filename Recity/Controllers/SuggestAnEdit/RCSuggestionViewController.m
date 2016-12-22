//
//  RCSuggestionViewController.m
//  Recity
//
//  Created by ezaji.dm on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionViewController.h"

#import "RCMapViewController.h"

#import "RCBaseNavigationController.h"

@implementation RCSuggestionViewController

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)close
{
    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    UIViewController *popViewController = [self firstControllerInNavigationWithClass:[RCMapViewController class]];
    [nav slideLayerInDirection:direction_bottom
                        andPop:popViewController];
}

- (UIViewController *)firstControllerInNavigationWithClass:(Class)classController
{
    UIViewController *result = nil;

    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    NSEnumerator *reverseEnumerator = nav.viewControllers.reverseObjectEnumerator;
    while((result = reverseEnumerator.nextObject)) {
        if([result isKindOfClass:classController])
            break;
    }
    return result;
}

@end
