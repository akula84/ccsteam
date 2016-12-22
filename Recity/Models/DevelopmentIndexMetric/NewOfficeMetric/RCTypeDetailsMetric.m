//
//  RCNewOfficeMetric.m
//  Recity
//
//  Created by Artem Kulagin on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTypeDetailsMetric.h"

#import "RCAddress.h"
#import "RCPredicateFactory.h"
#import "RCProject.h"
#import "isFull.h"
#import "RCTypeDetailsMetricView.h"
#import "RCIndexUtils.h"
#import "NSNumber+Grouped.h"
#import "RCIndexUtils.h"

@implementation RCTypeDetailsMetric

- (void)loadData
{
    NSArray *filter = [self.address nearbyProjectNotUnannounce];
    NSPredicate *predOffice = [self predTypeDetails];
    filter = [filter filteredArrayUsingPredicate:predOffice];
   
    NSArray *underArray = [filter filteredArrayUsingPredicate:[RCPredicateFactory predUnder]];
    NSArray *plannedArray = [filter filteredArrayUsingPredicate:[RCPredicateFactory predPlanned]];
    NSArray *underPlanned = [underArray arrayByAddingObjectsFromArray:plannedArray];
    
    self.planned =[self prepareValue:plannedArray];
    self.under = [self prepareValue:underArray];
    self.completed = [self prepareValue:[filter filteredArrayUsingPredicate:[RCPredicateFactory predCompleted]]];
    
    if (!([RCIndexUtils aviableArray:underPlanned]&&(self.sumPlannedUnderComplete.intValue != 0))) {
        self.descriptionTitle = kNotEnough;
        self.enabled = NO;
        return;
    }
    self.enabled = YES;
    
    [self prepareDescription:underPlanned];
}

- (void)prepareDescription:(NSArray *)arrayProject
{
    
    NSString *sumTitle = [self sumTitle];
    NSString *yearStringBy = [RCIndexUtils yearStringBy:arrayProject];
    self.descriptionTitle = [NSString stringWithFormat:@"%@%@%@", sumTitle, [self textDescription], yearStringBy];
}

- (NSNumber *)sumPlannedUnder
{
    return @(self.planned.intValue + self.under.intValue);
}

- (NSNumber *)sumPlannedUnderComplete
{
    return @(self.planned.intValue + self.under.intValue + self.completed.intValue);
}

- (NSString *)sumTitle
{
    return [NSString stringWithFormat:@"%@",[[self sumPlannedUnderComplete] groupSqFT]];
}

- (NSString *)textDescription
{
    return @"";
}

- (BOOL)aviableData:(NSArray *)array
{
    return array.count >= 2;
}

- (void)prepareDescription{}


- (NSNumber *)prepareValue:(NSArray *)array
{
    return nil;
}

- (NSPredicate *)predTypeDetails
{
    return nil;
}

- (NSString *)suffixCount
{
    return @" SQ FT";
}

- (UIView *)viewForMetric
{
    RCTypeDetailsMetricView *metricView = [[RCTypeDetailsMetricView alloc] initForAutoLayout];
    [metricView setModel:self type:[self prepareType]];
    return metricView;
}

- (RCGroupType)prepareType
{
    return RCGroupTypeSqFt;
}

- (CGFloat)heightForView
{
    return 140.0f;
}

@end
