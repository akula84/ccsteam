//
//  RCAreaPermitView.m
//  Recity
//
//  Created by Artem Kulagin on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAreaPermitView.h"

#import "RCAreaPermitMetric.h"
#import "RCAreaPermitCell.h"

@interface RCAreaPermitView()

@property (weak, nonatomic) IBOutlet RCAreaPermitCell *oneAgoView;
@property (weak, nonatomic) IBOutlet RCAreaPermitCell *twoAgoView;
@property (weak, nonatomic) IBOutlet RCAreaPermitCell *threeAgoView;
@property (strong, nonatomic) RCAreaPermitMetric *model;

@end

@implementation RCAreaPermitView

- (void)setModel:(RCAreaPermitMetric *)model
{
    _model = model;
    
    NSNumber *maxValue = [self maxValue:model];
    [self.oneAgoView setPercent:model.oneAgo maxValue:maxValue];
    [self.twoAgoView setPercent:model.twoAgo maxValue:maxValue];
    [self.threeAgoView setPercent:model.threeAgo maxValue:maxValue];
    
    [self hideIfNeefGraph];
}

- (void)hideIfNeefGraph
{
    RCAreaPermitMetric *model = self.model;
    for (RCAreaPermitCell *view in @[self.oneAgoView,self.twoAgoView,self.threeAgoView]) {
        if (model.hideUp) {[view hideUp];}
        if (model.hideDown) {[view hideDown];}
    }
}

- (NSNumber *)maxValue:(RCAreaPermitMetric *)model
{
    CGFloat maxValue = 0.f;
    for (NSNumber *number in @[model.oneAgo,model.twoAgo,model.threeAgo]) {
        float floatValue = ABS(number.floatValue);
        if (floatValue > maxValue) {
            maxValue = floatValue;
        }
    }
    return @(maxValue);
}

@end
