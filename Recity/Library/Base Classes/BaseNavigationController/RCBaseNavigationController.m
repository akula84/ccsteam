//
//  RCBaseNavigationController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseNavigationController.h"

@interface RCBaseNavigationController ()

@end

@implementation RCBaseNavigationController

- (void)slideLayerInDirection:(NSString *)direction
                      andPush:(UIViewController *)dstVC
{
    [self configureTranstionAndAnimationWithDirection:direction];
    [self pushViewController:dstVC animated:NO];
}

- (void)slideAndPopLayerInDirection:(NSString *)direction
{
    [self configureTranstionAndAnimationWithDirection:direction];
    [self popViewControllerAnimated:NO];
}

- (void)slideLayerInDirection:(NSString *)direction
                       andPop:(UIViewController *)popVC {
    [self configureTranstionAndAnimationWithDirection:direction];
    [self popToViewController:popVC animated:NO];
}

- (void)configureTranstionAndAnimationWithDirection:(NSString *)direction {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = direction;
    [self.view.layer addAnimation:transition forKey:kCATransition];
}

@end
