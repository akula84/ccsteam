//
//  RCDetailsPageController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 16.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDetailsPageController.h"

@implementation RCDetailsPageController

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    for (UIScrollView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = scrollEnabled;
            return;
        }
    }
}

@end
