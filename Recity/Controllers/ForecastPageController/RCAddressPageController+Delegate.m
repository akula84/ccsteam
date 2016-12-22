//
//  RCIndexPageController+Delegate.m
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddressPageController_Private.h"

@implementation RCAddressPageController (Delegate)

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.items indexOfObject:viewController];
    if(currentIndex == 0)
        return nil;
    
    UIViewController *cVC = [self.items objectAtIndex:currentIndex - 1];
    return cVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.items indexOfObject:viewController];
    if(currentIndex == self.items.count - 1)
        return nil;
    
    UIViewController *cVC = [self.items objectAtIndex:currentIndex + 1];
    return cVC;
}

@end
