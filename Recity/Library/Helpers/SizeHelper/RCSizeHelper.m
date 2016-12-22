//
//  RCSizeHelper.m
//  Recity
//
//  Created by Artem Kulagin on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSizeHelper.h"

static const CGFloat detailsHalfDisplayedFloatViewHeight = 169.f;
static const CGFloat defaultWidthScreen = 320.f;

@implementation RCSizeHelper

+ (CGFloat)detailsHalfHeight
{
    return (int)(detailsHalfDisplayedFloatViewHeight * self.koefScreenWidth);
}

+ (CGFloat)screenWidth
{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

+ (CGFloat)koefScreenWidth
{
    return self.screenWidth/defaultWidthScreen;
}

@end
