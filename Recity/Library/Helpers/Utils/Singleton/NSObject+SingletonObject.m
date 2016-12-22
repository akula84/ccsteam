//
//  NSObject+SingletonObject.m
//
//  Created by Alexander Kozin on 24/01/14.
//

#import "NSObject+SingletonObject.h"

#import "AppProtection.h"

@interface NSObject (SingletonObject_Private)

- (instancetype)init NS_UNAVAILABLE;

@end

@implementation NSObject (SingletonObject)

+ (instancetype)shared
{
    NSAssert(NO, @"This method should be used only in singletones");
    return nil;
}

- (void)prepareSingleton
{
}

@end
