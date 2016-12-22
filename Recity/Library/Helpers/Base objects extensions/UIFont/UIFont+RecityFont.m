//
//  UIFont+RecityColor.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "UIFont+RecityFont.h"

@implementation UIFont (RecityFont)

+ (UIFont *)flamaBook13
{
    return [self flamaBook:13.f];
}

+ (UIFont *)flamaBasic14
{
    return [self flamaBasic:14.f];
}

+ (UIFont *)flamaBook:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Flama-Book" size:fontSize];
}

+ (UIFont *)flamaBasic:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Flama-Basic" size:fontSize];
}

@end
