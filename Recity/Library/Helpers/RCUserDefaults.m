//
//  NMBUserDefaultsController.m
//  neemble
//
//  Created by Artem Kulagin on 04.03.16.
//  Copyright © 2016 El-Machine. All rights reserved.
//

#import "RCUserDefaults.h"

static NSString* kModifiedSince = @"Modified-Since";

@implementation RCUserDefaults

+ (NSUserDefaults *)settings
{
    return [NSUserDefaults standardUserDefaults];
}

+ (id)objectValue:(NSString *)key
{
    NSUserDefaults *settings = [self settings];
    return [settings objectForKey:key];
}

+ (NSInteger)integerValue:(NSString *)key
{
    NSUserDefaults *settings = [self settings];
    return [settings integerForKey:key];
}

+ (void)saveIntegerValue:(NSInteger)value key:(NSString *)key
{
    NSUserDefaults *settings = [self settings];
    [settings setInteger:value forKey:key];
    [settings synchronize];
}

+ (void)saveObjectValue:(id)value key:(NSString *)key
{
    NSUserDefaults *settings = [self settings];
    [settings setObject:value forKey:key];
    [settings synchronize];
}

+ (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *settings = [self settings];
    [settings removeObjectForKey:key];
    [settings synchronize];
}

+ (NSDate *)modifiedSince
{
    return [self objectValue:kModifiedSince];
}

+ (void)saveModifiedSince:(NSDate *)date
{
    [self saveObjectValue:date key:kModifiedSince];
}

@end
