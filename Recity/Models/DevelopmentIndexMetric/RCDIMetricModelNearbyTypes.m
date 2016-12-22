//
//  RCDIMetricModelNearbyTypes.m
//  Recity
//
//  Created by Vitaliy Zhukov on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDIMetricModelNearbyTypes.h"

#import "RCDINearbyTypesViewController.h"
#import "RCAddress.h"
#import "RCSegmentedProcentageSelector.h"
#import "RCPredicateFactory.h"
#import "RCIndexUtils.h"

@interface RCDIMetricModelNearbyTypes() <RCSegmentedProcentageSelectorDelegate>

@property (strong, nonatomic) RCDINearbyTypesViewController *viewController;
@property (strong, nonatomic) RCSegmentedProcentageSelector *selector;
@property (nonatomic) NSUInteger projectsCount;
@property (nonatomic) NSUInteger currentGroupIndex;

@property (strong, nonatomic) NSArray *dataModel;
@property (strong, nonatomic) NSArray *valuesForSelector;

@end

@implementation RCDIMetricModelNearbyTypes

- (void)prepareDescription
{
    self.descriptionTitle = [NSString stringWithFormat:@"%lu Nearby Projects", (unsigned long)self.projectsCount];
}

- (void)loadData
{
    if (!self.dataModel) {
        RCAddress *address = self.address;
        
        NSArray *nearbyProjects = [address nearbyProjectNotUnannounce];
        if ([RCIndexUtils aviableArray:nearbyProjects]) {
            
            self.enabled = YES;
            
            self.projectsCount = nearbyProjects.count;
            
            NSArray *resideintial = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsResidential]];
            NSArray *retail = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsRetail]];
            NSArray *hotel = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsHotel]];
            NSArray *office = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsOffice]];
            NSArray *entertainment = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsEntertainment]];
            NSArray *other = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsOther]];
            
             self.dataModel = @[
                                @{ @"title" : @"Residential size", @"data" : resideintial, @"key" : @"residential" },
                                @{ @"title" : @"Office size", @"data" : office, @"key" : @"office" },
                                @{ @"title" : @"Hotel size", @"data" : hotel, @"key" : @"hotel" },
                                @{ @"title" : @"Retail size", @"data" : retail, @"key" : @"retail" },
                                @{ @"title" : @"Entertainment size", @"data" : entertainment, @"key" : @"entertainment" },
                                @{ @"title" : @"Other", @"data" : other, @"key" : @"otherType" }
                                ];
            
            NSMutableArray *tmpData = [NSMutableArray array];
            
            for (NSDictionary *data in self.dataModel) {
                if ([data[@"data"] isFull]) {
                    [tmpData addObject:data];
                }
            }
            
            self.dataModel = tmpData;
            
            self.viewController = [RCDINearbyTypesViewController instantiateFromStoryboardNamed:@"DevelopmentIndex"];
            self.viewController.address = address;
            [self updateData];
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
        
        NSString *valueKey = [NSString stringWithFormat:@"%@Size", data[@"key"]];
        NSString *estimatedValueKey = [NSString stringWithFormat:@"estimated%@Size", [self capitalizeFirstLetter:data[@"key"]]];
        
        dataCount += [[data[@"data"] valueForKeyPath:[NSString stringWithFormat:@"@sum.typeDetails.%@", valueKey]] floatValue];
        dataCount += [[data[@"data"] valueForKeyPath:[NSString stringWithFormat:@"@sum.typeDetails.%@", estimatedValueKey]] floatValue];
    }
    
    CGFloat projectsPerPercent = dataCount / 100.0f;
    
    for (NSDictionary *data in self.dataModel) {
        
        NSString *valueKey = [NSString stringWithFormat:@"%@Size", data[@"key"]];
        NSString *estimatedValueKey = [NSString stringWithFormat:@"estimated%@Size", [self capitalizeFirstLetter:data[@"key"]]];
        
        CGFloat categoryData = [[data[@"data"] valueForKeyPath:[NSString stringWithFormat:@"@sum.typeDetails.%@", valueKey]] floatValue];
        categoryData += [[data[@"data"] valueForKeyPath:[NSString stringWithFormat:@"@sum.typeDetails.%@", estimatedValueKey]] floatValue];
        
        [values addObject:@(categoryData / projectsPerPercent)];
    }
    self.valuesForSelector = values;
}

- (NSString *)capitalizeFirstLetter:(NSString *)string
{
    return [NSString stringWithFormat:@"%@%@",[[string substringToIndex:1] uppercaseString],[string substringFromIndex:1] ];
}

- (UIView *)viewForMetric
{
    [self updateCategoryTitle];
    UIView *metricView = self.viewController.view;
    self.selector = self.viewController.segmentedSelector;
    self.selector.delegate = self;
    self.selector.values = self.valuesForSelector;
    return metricView;
}

- (CGFloat)heightForView
{
    return [self.viewController viewHeight];
}

- (void)segmentedSelectorDidSelectSegmentAtIndex:(NSUInteger)index
{
    self.currentGroupIndex = index;
    [self updateData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMetricsCellNeedReload object:self];
}

- (void)updateData
{
    self.viewController.projects = self.dataModel[self.currentGroupIndex][@"data"];
}

- (void)updateCategoryTitle
{
    self.viewController.groupTitle = self.dataModel[self.currentGroupIndex][@"title"];
}

@end
