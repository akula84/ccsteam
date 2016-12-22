//
//  RCNewRetailMetric.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNewRetailMetric.h"

#import "RCPredicateFactory.h"
#import "RCIndexUtils.h"

@implementation RCNewRetailMetric

- (NSString *)textDescription
{
    return @" Sq Ft New Retail";
}

- (NSPredicate *)predTypeDetails
{
    return [RCPredicateFactory predTypeDetailsRetail];
}

- (NSNumber *)prepareValue:(NSArray *)array
{
    return [RCIndexUtils valueRetailSize:array];
}

@end
