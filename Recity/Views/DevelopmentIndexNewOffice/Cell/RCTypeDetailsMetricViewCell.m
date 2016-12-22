//
//  RCTypeDetailsMetricViewCell.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTypeDetailsMetricViewCell.h"

#import "UIFont+RecityFont.h"
#import "NSNumber+Grouped.h"

@interface RCTypeDetailsMetricViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewGraph;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betweenConstraint;

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelDescriptionDuble;

@end

@implementation RCTypeDetailsMetricViewCell

- (CGFloat)widthGraph
{
    CGFloat widthScreen = [[UIScreen mainScreen] bounds].size.width;
    return widthScreen - self.leftConstraint.constant - self.rightConstraint.constant - self.widthLabelConstraint.constant;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = self.title;
    self.viewGraph.backgroundColor = self.color;
}

- (void)prepareValue:(NSNumber *)metric maxMetric:(NSNumber *)maxMetric suffix:(NSString *)suffix type:(RCGroupType)type
{
    CGFloat widthGraph = [self widthGraph];
    CGFloat constant =  widthGraph * (1 - (metric.floatValue/maxMetric.floatValue));
    self.betweenConstraint.constant =  constant;
    NSString *title = [self titleWith:metric type:type];
    NSString *text = [NSString stringWithFormat:@"%@%@",title,suffix];
    self.labelDescription.text = self.labelDescriptionDuble.text = text;
}

- (NSString *)titleWith:(NSNumber *)metric type:(RCGroupType)type
{
    NSString *title;
    switch (type) {
        case RCGroupTypeDigit:
            title = [metric groupDigit];
            break;
        case RCGroupTypePlanned:
            title = [metric groupPlanned];
            break;
        case RCGroupTypeSqFt:
            title = [metric groupSqFT];
            break;
    }
    return title;
}

+ (CGFloat)heightDefault
{
    return 45.f;
}

- (void)prepareTitle:(NSString *)title
{
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont flamaBasic14];
    self.viewGraph.backgroundColor = [UIColor orangeColor];
}

@end
