//
//  RCPredicateFactory.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPredicateFactory.h"

@implementation RCPredicateFactory

+ (NSPredicate *)predUid:(id)uid
{
    return [self predIsEgual:kUid value:uid];
}

+ (NSPredicate *)predIsEgual:(NSString *)nameProperty value:(NSString *)value
{
    return [NSPredicate predicateWithFormat:@"%K == %@",nameProperty,value];
}

+ (NSPredicate *)predIsKind:(Class)aClass
{
    return [NSPredicate predicateWithFormat: @"self isKindOfClass: %@",aClass];
}

+ (NSPredicate *)predAddressLatitude:(id)latitude longitude:(id)longitude
{
    return [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude, longitude];
}

@end
