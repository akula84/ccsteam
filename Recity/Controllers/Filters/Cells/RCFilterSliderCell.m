//
//  RCFilterSliderCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterSliderCell.h"

#import <TTRangeSlider.h>

@interface RCFilterSliderCell() <TTRangeSliderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *valuesLabel;
@property (weak, nonatomic) IBOutlet TTRangeSlider *slider;

@end

@implementation RCFilterSliderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSlider];
}

- (void)updateWithModel:(RCFilterTableModel *)model
{
    [super updateWithModel:model];

    self.title.text = model.title;
    
    self.slider.maxValue = model.values.count - 1;
    self.slider.selectedMinimum = [model.values indexOfObject:model.currentMin];
    self.slider.selectedMaximum = [model.values indexOfObject:model.currentMax];
    
    [self updateValuesLabel];
}

- (void)setupSlider
{
    TTRangeSlider *slider = self.slider;
    slider.lineHeight = 5.0f;
    slider.handleImage = IMG(@"slider_handle");
    slider.handleDiameter = 16.0f;
    slider.selectedHandleDiameterMultiplier = 1.0f;
    slider.tintColorBetweenHandles = RGB(47, 49, 146);
    slider.enableStep = YES;
    slider.delegate = self;
    [self updateValuesLabel];
}

- (void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
    NSNumber *min = self.model.values[(NSUInteger)selectedMinimum];
    NSNumber *max = self.model.values[(NSUInteger)selectedMaximum];
    
    self.model.currentMin = min;
    self.model.currentMax = max;
    
    [self updateValuesLabel];
}

- (void)updateValuesLabel
{
    TTRangeSlider *s = self.slider;
    RCFilterTableModel *model = self.model;
    
    NSNumber *min = model.values[(NSUInteger)s.selectedMinimum];
    NSNumber *max = model.values[(NSUInteger)s.selectedMaximum];
    
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    NSString *minStr = s.selectedMinimum == 0 ? @"No Min" : [formatter stringFromNumber:min];
    NSString *maxStr = s.selectedMaximum == model.values.count - 1 ? @"No Max" : [formatter stringFromNumber:max];
    
    self.valuesLabel.text = [NSString stringWithFormat:@"%@ - %@", minStr, maxStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
