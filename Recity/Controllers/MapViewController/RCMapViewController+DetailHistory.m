//
//  RCMapViewController+DetailHistory.m
//  Recity
//
//  Created by Vitaliy Zhukov on 28.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCDetailsPageController.h"
#import "RCProjectDetailsViewController.h"
#import "RCAddressPageController.h"
#import "RCFloatViewSlider.h"
#import "RCProject.h"
#import "RCAddress.h"
#import "RCItemProtocol.h"

@implementation RCMapViewController (DetailHistory)

- (void)showObjectInHistory:(id)object
{
    NSUInteger index = NSNotFound;
    
    if ([object isKindOfClass:[RCProject class]]) {
        index = [self indexInHistoryOfProject:(RCProject *)object];
    } else if ([object isKindOfClass:[RCAddress class]]) {
        index = [self indexInHistoryOfAddress:(RCAddress *)object];
    }
    
    UIPageViewControllerNavigationDirection direction;
    UIViewController *detailsController;
    
    if (index == NSNotFound) {
        UIViewController *detailsVC = [self newControllerForObject:object];
        
        [self.detailsHistory addObject:detailsVC];
        
        detailsController = detailsVC;
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        detailsController = self.detailsHistory[index];
        
        [self.detailsHistory removeObjectAtIndex:index];
        [self.detailsHistory addObject:detailsController];
        
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    BOOL animated = [self.floatViewSlider displayedState] != FloatViewStateHidden;

    [[self detailsPager] setViewControllers:@[detailsController] direction:direction animated:animated completion:nil];
    
    [self updateFloatSliderBindings];
    if([detailsController isKindOfClass:[RCAddressPageController class]]) {
        [(UIViewController<RCItemProtocol> *)detailsController prepareData];
    }
    
    [self.floatViewSlider hideMenuCompletion:nil andDisplayProjectDetailsAnimatedCompletion:nil];
    
    if ([detailsController respondsToSelector:@selector(address)]) {
        RCAddress *address = [detailsController performSelector:@selector(address)];
        if (!address.address.isFull) {
            [self.detailsHistory removeObject:detailsController];
        }
    }
    
    [self myLocationButtonUp:YES];
}

- (UIViewController *)newControllerForObject:(id)object
{
    UIViewController *result = nil;
    if ([object isKindOfClass:[RCProject class]]) {
        result = [self detailsViewControllerForProject:(RCProject *)object];
    } else if ([object isKindOfClass:[RCAddress class]]) {
        result = [self developmentIndexViewControllerForAddress:(RCAddress *)object];
    }
    
    return result;
}

- (void)updateFloatSliderBindings
{
    UIViewController <RCItemProtocol>*controller = (UIViewController <RCItemProtocol>*)[self currentDetailsController];
    [controller updateBindings];
}

- (NSUInteger)indexInHistoryOfController:(UIViewController *)controller
{
    return [self.detailsHistory indexOfObject:controller];
}

- (UIViewController *)currentDetailsController
{
    return [[self detailsPager].viewControllers firstObject];
}

- (void)prepareDetailsHistory
{
    [self detailsPager].dataSource = self;
    [self detailsPager].delegate = self;
    self.floatViewSlider.projectDetailsView = [self detailsPager].view;
    self.floatViewSlider.detailPager = [self detailsPager];
}

- (void)myLocationButtonUp:(BOOL)value
{
    [self.myLocationButtonConstrains setPriority:(value) ? 6 : 4 ];
}

- (RCDetailsPageController *)detailsPager
{
    return (RCDetailsPageController *)[self.childViewControllers firstObject];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    UIViewController *result = nil;
    NSUInteger idx = [self.detailsHistory indexOfObject:viewController];

    if(idx == NSNotFound) {
        result = self.detailsHistory.lastObject;
    } else if (idx > 0) {
        result = self.detailsHistory[idx - 1];
    }

    return result;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    UIViewController *result = nil;
    NSUInteger idx = [self.detailsHistory indexOfObject:viewController];
    
    if (idx != NSNotFound && idx < self.detailsHistory.count - 1) {
        result = self.detailsHistory[idx + 1];
    }
    
    return result;
}

/*
 * This is hack.
 */
- (void)invalidateCacheForDetailsPagerWithPreviousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
{
    UIViewController *previousViewController = previousViewControllers[0];
    if([previousViewController isKindOfClass:[RCAddressPageController class]]) {
        RCAddressPageController *addressPageController = (RCAddressPageController *)previousViewController;
        if (!addressPageController.address.address.isFull) {
            UIViewController *currentDetailsController = [self currentDetailsController];
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.detailsPager setViewControllers:@[currentDetailsController]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:NO
                                                    completion:nil];
            });
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (completed) {
        UIViewController *controller = [self currentDetailsController];
        if ([controller isKindOfClass:[RCProjectDetailsViewController class]]) {
            [self displayProjectOnMapAndAddToRecent:[(RCProjectDetailsViewController *)controller project]];
        } else if ([controller isKindOfClass:[RCAddressPageController class]]) {
            [self displayAddressOnMap:[(RCAddressPageController *)controller address]];
        }
        [self updateFloatSliderBindings];
        if(finished) {
            [self invalidateCacheForDetailsPagerWithPreviousViewControllers:previousViewControllers];
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    UIViewController *controller = [self currentDetailsController];
    if ([controller isKindOfClass:[RCProjectDetailsViewController class]]) {
        [(RCProjectDetailsViewController *)controller scrollToProjectDetailsSection];
    }

    UIViewController<RCItemProtocol> *updateController = (UIViewController <RCItemProtocol>*)pendingViewControllers.firstObject;
    if ([updateController isKindOfClass:[RCAddressPageController class]]) {
        [updateController prepareData];
    }
}

@end
