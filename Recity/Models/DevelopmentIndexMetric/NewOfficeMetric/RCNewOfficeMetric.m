//
//  NewOfficeMetric.m
//  Recity
//
//  Created by Artem Kulagin on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNewOfficeMetric.h"

#import "RCPredicateFactory.h"
#import "RCIndexUtils.h"

@implementation RCNewOfficeMetric

- (NSString *)textDescription
{
    return @" Sq Ft New Office";
}

- (NSPredicate *)predTypeDetails
{
    return [RCPredicateFactory predTypeDetailsOffice];
}

- (NSNumber *)prepareValue:(NSArray *)array
{
    return [RCIndexUtils valueOfficeSize:array];
}

@end
