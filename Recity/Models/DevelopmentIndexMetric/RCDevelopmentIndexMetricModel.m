//
//  RCDevelopmentIndexMetricModel.m
//  Recity
//
//  Created by Vitaliy Zhukov on 21.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexMetricModel.h"

@implementation RCDevelopmentIndexMetricModel

- (void)loadItem
{
    [self loadData];
    [self prepareDescription];
}

- (void)prepareDescription
{
    self.descriptionTitle = @"TEST DESCRIPTION";
}

- (void)loadData
{
    
}

+ (instancetype)modelWithTitle:(NSString *)title
{
    Class class = self;
    id model = [[class alloc] init];
    [(RCDevelopmentIndexMetricModel *)model setTitle:title];
    return model;
}

- (void)setAddress:(RCAddress *)address
{
    _address = address;
    [self loadItem];
}

- (NSString *)description
{
    return self.descriptionTitle;
}

- (UIView *)viewForMetric
{
    return nil;
}

- (CGFloat)heightForView
{
    return 100.0f;
}

@end
