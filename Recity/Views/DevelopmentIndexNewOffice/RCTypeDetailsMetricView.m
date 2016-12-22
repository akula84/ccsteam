//
//  RCNewOfficeView.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTypeDetailsMetricView.h"

#import "RCTypeDetailsMetric.h"
#import "RCTypeDetailsMetricViewCell.h"

@interface RCTypeDetailsMetricView()

@property (weak, nonatomic) IBOutlet RCTypeDetailsMetricViewCell *plannedView;
@property (weak, nonatomic) IBOutlet RCTypeDetailsMetricViewCell *underView;
@property (weak, nonatomic) IBOutlet RCTypeDetailsMetricViewCell *competView;

@end

@implementation RCTypeDetailsMetricView

- (void)setModel:(RCTypeDetailsMetric *)model type:(RCGroupType)type
{
    NSNumber *planned = model.planned;
    NSNumber *under = model.under;
    NSNumber *completed = model.completed;
    NSNumber *maxMetric = [@[planned,under,completed] valueForKeyPath:@"@max.self"];
    NSString *suffix = [model suffixCount];
    [self.plannedView prepareValue:planned maxMetric:maxMetric suffix:suffix type:type];
    [self.underView prepareValue:under maxMetric:maxMetric suffix:suffix type:type];
    [self.competView prepareValue:completed maxMetric:maxMetric suffix:suffix type:type];
}

@end
