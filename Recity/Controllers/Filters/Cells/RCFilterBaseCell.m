//
//  RCFilterBaseCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterBaseCell.h"

#import <TTRangeSlider.h>

@implementation RCFilterBaseCell

- (void)updateWithModel:(RCFilterTableModel *)model
{
    self.model = model;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    for (UIView *view in self.contentView.subviews) {
        view.alpha = userInteractionEnabled ? 1.0f : 0.3f;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}

@end
