//
//  RCPlannedTimeline.m
//  Recity
//
//  Created by Artem Kulagin on 28.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPlannedTimelineView.h"

#import "RCPlannedTimelineMetric.h"
#import "RCTypeDetailsMetricViewCell.h"
#import "UIFont+RecityFont.h"
#import "UIColor+RCColor.h"
#import "RCAddressController.h"

@interface RCPlannedTimelineView()

@property (weak, nonatomic) IBOutlet UILabel *forecastTitle;

@end

@implementation RCPlannedTimelineView

- (IBAction)forecastAction:(id)sender
{
   [RCAddressController selectForecast];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareForecastTitle];
    }
    return self;
}

- (void)prepareForecastTitle
{
    NSString *one = @"For a more detailed look at upcoming projects, head over to ";
    NSString *two = @" Forecast";
    NSString *string = [NSString stringWithFormat:@"%@ %@",one,two];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger twoLength = two.length;
    NSUInteger fullLength = string.length;
    NSRange fullRange = NSMakeRange(0,fullLength);
    NSRange twoRange = NSMakeRange(fullLength - twoLength,twoLength);
    [attrString addAttribute:NSFontAttributeName value:[UIFont flamaBook13] range:fullRange];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleRCColor] range:twoRange];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"forecast"];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attrString insertAttributedString:attrStringWithImage atIndex:fullLength - twoLength] ;

    self.forecastTitle.attributedText = attrString;
}

- (void)setModel:(RCPlannedTimelineMetric *)model
{
    CGFloat offset  = 34.f;
    CGFloat heightCell = [RCTypeDetailsMetricViewCell heightDefault];
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithDictionary:model.values];
    NSArray *keys = [values.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *allValues = values.allValues;
    NSNumber *maxValue = [allValues valueForKeyPath:@"@max.self"];
    
    NSString *suffix = @" SQ FT";
    CGFloat widthScreen = [[UIScreen mainScreen] bounds].size.width;
    for (NSString *key in keys) {
        CGRect rect = CGRectMake(0, offset, widthScreen, heightCell);
        RCTypeDetailsMetricViewCell *view = [[RCTypeDetailsMetricViewCell alloc]initWithFrame:rect];
        [view prepareTitle:key];
        [view prepareValue:values[key]  maxMetric:maxValue suffix:suffix type:RCGroupTypePlanned];
        [self addSubview:view];
        offset = offset + heightCell;
     }
}

@end
