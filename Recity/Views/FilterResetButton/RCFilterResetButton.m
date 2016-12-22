//
//  RCFilterResetButton.m
//  Recity
//
//  Created by Vitaliy Zhukov on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFilterResetButton.h"

@implementation RCFilterResetButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = RGB(47, 49, 146).CGColor;
    self.layer.borderWidth = 1.25f;
    self.layer.cornerRadius = 3.0f;
    self.clipsToBounds = YES;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        self.layer.borderColor = RGB(47, 49, 146).CGColor;
    } else {
        self.layer.borderColor = RGB(184, 184, 184).CGColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = RGB(47, 49, 146);
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:RGB(47, 49, 146) forState:UIControlStateNormal];
    }
}

@end
