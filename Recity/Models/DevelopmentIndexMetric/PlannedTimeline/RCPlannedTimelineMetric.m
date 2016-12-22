//
//  RCPlannedTimelineMetric.m
//  Recity
//
//  Created by Artem Kulagin on 28.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPlannedTimelineMetric.h"

#import "RCAddress.h"
#import "RCPredicateFactory.h"
#import "RCProject.h"
#import "RCIndexUtils.h"
#import "RCPlannedTimelineView.h"
#import "RCTypeDetailsMetricViewCell.h"
#import "NSNumber+Grouped.h"

@implementation RCPlannedTimelineMetric

- (void)loadItem
{
    NSArray *allProject = [self.address nearbyProjectNotUnannounce];
    NSPredicate *pred = [NSCompoundPredicate orPredicateWithSubpredicates:@[[RCPredicateFactory predUnder],[RCPredicateFactory predPlanned]]];
    NSArray *plannedsUnder = [allProject filteredArrayUsingPredicate:pred];

    if (![RCIndexUtils aviableArray:plannedsUnder]) {
        self.descriptionTitle = kNotEnough;
        self.enabled = NO;
        return;
    }
    self.enabled = YES;
    self.descriptionTitle = [NSString stringWithFormat:@"%@ Planned Projects",[@(plannedsUnder.count) groupDigit]];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (RCProject *project in plannedsUnder) {
        NSString *key = [self keyFrom:project];
        NSNumber *value = [RCIndexUtils valueBuildingSize:project];
        NSNumber *existValue = result[key];
        result[key] = @(existValue.floatValue + value.floatValue);
    }
    self.values = [NSDictionary dictionaryWithDictionary:result];
}

- (NSString *)keyFrom:(RCProject *)project
{
    NSString *key = kTBD;
    NSDate *date = [project expectedCompletionDate];
    if (date) {
        key = [NSString stringWithFormat:@"%@",@(date.year)];
    }
    return key;
}

- (UIView *)viewForMetric
{
    RCPlannedTimelineView *metricView = [[RCPlannedTimelineView alloc] initForAutoLayout];
    [metricView setModel:self];
    return metricView;
}

- (CGFloat)heightForView
{
    CGFloat size = 98.f;
    CGFloat heightCells = [RCTypeDetailsMetricViewCell heightDefault] * self.values.allKeys.count;
    return size + heightCells;
}

@end
