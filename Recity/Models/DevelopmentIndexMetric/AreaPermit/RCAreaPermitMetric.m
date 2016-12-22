//
//  RCAreaPermitMetric.m
//  Recity
//
//  Created by Artem Kulagin on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAreaPermitMetric.h"

#import "RCAreaPermitView.h"
#import "RCAddress.h"
#import "RCIndexUtils.h"

static CGFloat const heightHalfDots = 63.f;

@implementation RCAreaPermitMetric

- (void)loadData
{
    RCAddress *address = self.address;
    NSNumber *one = address.permitsTwoToThreeYears;
    NSNumber *two = address.permitsOneToTwoYears;
    NSNumber *three = address.permitsZeroToOneYear;
    if (!(one.isFull|two.isFull|three.isFull)) {
        [self prepareNoAviable];
        self.enabled = NO;
        return;
    }
    self.enabled = YES;
     
    one = [self convertPercent:one];
    two = [self convertPercent:two];
    three = [self convertPercent:three];

    NSNumber *sum = [@[one,two,three] valueForKeyPath:@"@avg.self"];
    CGFloat sumFloat = sum.floatValue;
    NSString *descriptionTitle = self.descriptionTitle;
    if (sumFloat > 20.f) {
        descriptionTitle = @"More Permit Activity than City Median";
    }else if (sumFloat < 20.f){
        descriptionTitle = @"Less Permit Activity than City Median";
    }else if (-20.0f < sumFloat < 20.f){
        descriptionTitle = @"Average Permit Activity";
    }
    self.descriptionTitle = descriptionTitle;
    self.oneAgo = one;
    self.twoAgo = two;
    self.threeAgo = three;

    [self calculateHeight];
    
    RUN_BLOCK(self.update);
}

- (void)calculateHeight
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self > 0"];
    NSArray *numbers = @[self.oneAgo,self.twoAgo,self.threeAgo];
    NSArray *result = [numbers filteredArrayUsingPredicate:pred];
    
    NSUInteger resultCount = result.count;
    self.hideUp = (resultCount == 0);
    self.hideDown = (resultCount == numbers.count);
}

- (void)prepareNoAviable
{
    self.descriptionTitle = @"Loading data…";
}

- (void)prepareDescription
{}

-(NSNumber *)convertPercent:(NSNumber *)value
{
    return @(lroundf((value.floatValue - 1.f) * 100));
}

- (UIView *)viewForMetric
{
    RCAreaPermitView *metricView = [[RCAreaPermitView alloc] initForAutoLayout];
    [metricView setModel:self];
    return metricView;
}

- (CGFloat)heightForView
{
    CGFloat height = 263.f;
    if (self.hideUp||self.hideDown) {
        height = height - heightHalfDots;
    }
    return height;
}

@end
