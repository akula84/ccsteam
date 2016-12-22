//
//  UIViewController+Storyboard.m
//  Initializer
//
//  Created by Valentina Chernoeva on 26.10.15.
//  Copyright © 2015 Magora Systems. All rights reserved.
//

#import "UIViewController+Storyboard.h"

//#warning - Сheck storyboard name

//NSString *const UIStoryboardMainIdetifier = @"Main";

@implementation UIViewController (Storyboard)

+ (instancetype)instantiateFromStoryboardNamed:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

@end
