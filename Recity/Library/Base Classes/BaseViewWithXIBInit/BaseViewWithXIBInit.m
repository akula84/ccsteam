//
//  BaseViewWithXIBInit.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "BaseViewWithXIBInit.h"

#import <PureLayout/PureLayout.h>

@implementation BaseViewWithXIBInit

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self){
       [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *views = [mainBundle loadNibNamed:[self nibNamed]
                                        owner:self
                                      options:nil];
    
    if (!views.isFull) {
        NSAssert(NO, @"Create XIB with same name as class");
    }
    
    UIView *view = views[0];
    [self addSubview:view];
    [view autoPinEdgesToSuperviewEdges];
}

- (NSString *)nibNamed
{
    return NSStringFromClass([self class]);
}

@end
