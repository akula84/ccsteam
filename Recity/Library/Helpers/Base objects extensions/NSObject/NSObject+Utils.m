//
//  NSObject+Utils.m
//  Test
//
//  Created by El-Machine on 5/2/12.
//  Copyright (c) 2012 Cookie. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

+ (id)object
{
    return [[self alloc] init];
}

+ (id)objectFromXib
{
    return [self objectFromXib:[self nibName] withOwner:nil];
}

+ (id)objectFromXibWithOwner:(id)owner
{
    return [self objectFromXib:[self nibName] withOwner:owner];
}

+ (id)objectFromXib:(NSString*)nibName withOwner:(id)owner
{
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil] objectAtIndex:0];;
}

+ (NSString*)nibName
{
    return NSStringFromClass([self class]);
}

- (UIWindow *)mainWindow
{
    return [[[UIApplication sharedApplication] windows] firstObject];
}

- (UIViewController *)rootViewController
{
    return [self.mainWindow rootViewController];
}

@end
