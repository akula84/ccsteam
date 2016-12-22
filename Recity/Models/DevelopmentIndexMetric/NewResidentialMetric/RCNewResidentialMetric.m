//
//  RCNewResidentialMetric.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNewResidentialMetric.h"

#import "RCPredicateFactory.h"
#import "RCIndexUtils.h"
#import "NSNumber+Grouped.h"
#import "RCTypeDetailsMetricView.h"

@implementation RCNewResidentialMetric

- (NSString *)sumTitle
{
    NSInteger sum = self.planned.intValue + self.under.intValue + self.completed.intValue;
    return [NSString stringWithFormat:@"%@",[@(sum) groupDigit]];
}

- (NSString *)suffixCount
{
    return @" UNITS";
}

- (NSString *)textDescription
{
    return @" New Units";
}

- (NSPredicate *)predTypeDetails
{
    return [RCPredicateFactory predTypeDetailsResidential];
}

- (NSNumber *)prepareValue:(NSArray *)array
{
    return [RCIndexUtils valueResidentialUnits:array];
}

- (RCGroupType)prepareType
{
    return RCGroupTypeDigit;
}

@end
