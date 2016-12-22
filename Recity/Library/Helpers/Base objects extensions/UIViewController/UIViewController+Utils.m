//
//  UIViewController+Utils.m
//  Dishero
//
//  Created by El-Machine on 04.07.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

+ (__kindof UIViewController *)controller
{
    UIViewController *controller = [self controllerWithIdentifier:[self identifierToInstantiate]];

    return controller;
}

+ (__kindof UIViewController *)controllerWithIdentifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [self storyboard];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];

    return controller;
}

+ (__kindof UIViewController *)initialController
{
    return [[self storyboard] instantiateInitialViewController];
}

+ (UIStoryboard *)storyboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[self storyboardName]
                                                         bundle:nil];
    return storyboard;
}

+ (NSString *)identifierToInstantiate
{
    return NSStringFromClass(self);
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
}

+ (NSString *)storyboardName
{
    return @"Main";
}

@end
