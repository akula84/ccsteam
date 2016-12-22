//
//  RCDevelopmentIndexFootageByStatusView.m
//  Recity
//
//  Created by Vitaliy Zhukov on 27.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexFootageByStatusView.h"

#import "RCSegmentedProcentageSelector.h"
#import "NSNumber+Grouped.h"

@interface RCDevelopmentIndexFootageByStatusView() <RCSegmentedProcentageSelectorDelegate>

@property (weak, nonatomic) IBOutlet RCSegmentedProcentageSelector *segmentedSelector;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *footageLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectsCountLabel;

@end

@implementation RCDevelopmentIndexFootageByStatusView

- (void)setValues:(NSArray *)values
{
    _values = values;
    
    self.segmentedSelector.delegate = self;
    self.segmentedSelector.values = [values valueForKeyPath:@"percents"];
    
    [self updateUIForIndex:0];
}

- (void)segmentedSelectorDidSelectSegmentAtIndex:(NSUInteger)index
{
    [self updateUIForIndex:index];
}

- (void)updateUIForIndex:(NSUInteger)index
{
    NSDictionary *item = self.values[index];
    
    self.segmentedSelector.selectionColor = item[@"color"];
    self.statusLabel.text = item[@"title"];
 
    NSNumber *footage = item[@"value"];
    NSString *footageString = [NSString stringWithFormat:@"%@ SQ FT", [footage groupSqFT]];
    
    if (![item[@"title"] isEqualToString:@"Completed"]) {
        footageString = [footageString stringByAppendingString:[item[@"year"] uppercaseString]];
    }
    
    self.footageLabel.text = footageString;
    
    NSInteger projectsCount = [item[@"count"] integerValue];
    if (projectsCount == 1) {
        self.projectsCountLabel.text = [NSString stringWithFormat:@"1 PROJECT"];
    } else {
        self.projectsCountLabel.text = [NSString stringWithFormat:@"%lu PROJECTS", (unsigned long)projectsCount];
    }
}

@end
