//
//  RCDIMetricModelFootageByStatus.m
//  Recity
//
//  Created by Vitaliy Zhukov on 27.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDIMetricModelFootageByStatus.h"
#import "RCAddress.h"
#import "RCDevelopmentIndexFootageByStatusView.h"
#import "RCPredicateFactory.h"
#import "RCProject.h"
#import "NSNumber+Grouped.h"
#import "RCIndexUtils.h"

@interface RCDIMetricModelFootageByStatus()

@property (strong, nonatomic) NSArray *dataModel;
@property (strong, nonatomic) NSArray *valuesForView;

@property (nonatomic) CGFloat totalValue;

@property (strong, nonatomic) NSString *yearString;

@property (weak, nonatomic) RCDevelopmentIndexFootageByStatusView *metricView;

@end

@implementation RCDIMetricModelFootageByStatus

- (void)prepareDescription
{
    if (self.enabled) {
        NSString *valueString = [@(self.totalValue) groupSqFT];
        self.descriptionTitle = [NSString stringWithFormat:@"%@ Total New Sq Ft%@", valueString, self.yearString];
    } else {
        self.descriptionTitle = kNotEnough;
    }
}

- (void)loadData
{
    if (!self.dataModel) {
        NSArray *nearbyProjects = [self.address nearbyProjectNotUnannounce];
        
        if ([RCIndexUtils aviableArray:nearbyProjects]) {
            self.enabled = YES;
            NSArray *completed = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predCompleted]];
            NSArray *construction = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predUnder]];
            NSArray *planned = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predPlanned]];
            
            self.yearString = [self yearStringBy:[construction arrayByAddingObjectsFromArray:planned]];
            
            self.totalValue = [[construction  valueForKeyPath:@"@sum.buildingSize"] floatValue];
            self.totalValue += [[construction valueForKeyPath:@"@sum.estimatedBuildingSize"] floatValue];
            self.totalValue += [[planned  valueForKeyPath:@"@sum.buildingSize"] floatValue];
            self.totalValue += [[planned valueForKeyPath:@"@sum.estimatedBuildingSize"] floatValue];
            
            self.dataModel = @[
                               @{ @"title" : @"Completed", @"color":MGRColorWithHex(@"30AD24"), @"data" : completed },
                               @{ @"title" : @"Under Construction", @"color": MGRColorWithHex(@"D60B31"), @"data" : construction },
                               @{ @"title" : @"Planned", @"color": MGRColorWithHex(@"0096DA"), @"data" : planned },
                               ];
            
            NSMutableArray *tmpData = [NSMutableArray array];
            
            for (NSDictionary *data in self.dataModel) {
                if ([data[@"data"] isFull]) {
                    [tmpData addObject:data];
                }
            }
            
            self.dataModel = tmpData;
            
            [self updateDataForSelector];
        } else {
            self.enabled = NO;
        }
    }
}

- (void)updateDataForSelector
{
    NSMutableArray *values = [NSMutableArray array];
    
    CGFloat dataCount = 0;
    
    for (NSDictionary *data in self.dataModel) {
        dataCount += [[data[@"data"] valueForKeyPath:@"@sum.buildingSize"] floatValue];
        dataCount += [[data[@"data"] valueForKeyPath:@"@sum.estimatedBuildingSize"] floatValue];
    }
    
    CGFloat projectsPerPercent = dataCount / 100.0f;
    
    for (NSDictionary *data in self.dataModel) {
        
        NSUInteger projectsCount = [data[@"data"] count];
        
        CGFloat projectsValue = [[data[@"data"] valueForKeyPath:@"@sum.buildingSize"] floatValue];
        projectsValue += [[data[@"data"] valueForKeyPath:@"@sum.estimatedBuildingSize"] floatValue];
        
        CGFloat procentage = projectsValue / projectsPerPercent;

        [values addObject:@{@"title": data[@"title"],
                            @"color": data[@"color"],
                            @"count": @(projectsCount),
                            @"percents": @(procentage),
                            @"value" : @(projectsValue),
                            @"year" : [self yearStringBy:data[@"data"]]}];
    }
    self.valuesForView = values;
}

- (NSString *)yearStringBy:(NSArray *)arrayProject
{
    return [RCIndexUtils yearStringBy:arrayProject];
}
/*
- (NSString *)dateString:(NSArray *)arrayProject
{
    if (!arrayProject.isFull) {
        return [self yearDate:[NSDate date]];
    }
    NSInteger maxYear = [arrayProject.firstObject expectedCompletionDate].year;
    for (NSUInteger i = 1; i < arrayProject.count; i++) {
        NSInteger year = [arrayProject[i] expectedCompletionDate].year;
        if (year > maxYear) {
            maxYear = year;
        }
    }
    return maxYear?[NSString stringWithFormat:@"%@",@(maxYear)]:kTBD;
}

- (NSString *)yearDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%@",@(date.year)];
}
*/
- (UIView *)viewForMetric
{
    RCDevelopmentIndexFootageByStatusView *metricView = [[RCDevelopmentIndexFootageByStatusView alloc] initForAutoLayout];
    
    metricView.values = self.valuesForView;
    
    self.metricView = metricView;
    
    return metricView;
}

- (CGFloat)heightForView
{
    return 110.0f;
}

@end
