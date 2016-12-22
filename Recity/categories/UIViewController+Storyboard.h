//
//  UIViewController+Storyboard.h
//  Initializer
//
//  Created by Valentina Chernoeva on 26.10.15.
//  Copyright © 2015 Magora Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const UIStoryboardMainIdetifier;

@interface UIViewController (Storyboard)

+ (instancetype)instantiateFromStoryboardNamed:(NSString *)storyboardName;

@end
