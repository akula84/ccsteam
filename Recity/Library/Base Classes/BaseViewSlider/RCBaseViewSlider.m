//
//  RCBaseViewSlider.m
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseViewSlider.h"

@implementation RCBaseViewSlider

- (instancetype)initWithFloatView:(UIView *)view fundamentView:(UIView *)fundamentView floatViewBottomLayout:(NSLayoutConstraint *)floatViewBottomLayout floatViewHeightConstraint:(NSLayoutConstraint *)floatViewHeightConstraint {
    self = [super init];
    if (self) {
        self.fundamentView = fundamentView;
        self.floatView = view;
        self.floatViewBottomLayout = floatViewBottomLayout;
        self.floatViewHeightConstraint = floatViewHeightConstraint;
    }
    return self;
}

- (void)switchToState:(NSInteger)state animated:(BOOL)animated completion:(dispatch_block_t)completion {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

- (NSInteger)displayedState {
    THROW_MISSED_IMPLEMENTATION_EXCEPTION;
}

@end
