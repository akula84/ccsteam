//
//  SpacedLabel.m
//  YandexTV
//
//  Created by Arello Mobile on 24/07/15.
//  Copyright (c) 2015 Victor Eysner. All rights reserved.
//

#import "RCSpacedLabel.h"

@interface RCSpacedLabel ()

@property (assign, nonatomic) IBInspectable CGFloat spacing;

@end

@implementation RCSpacedLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setText:self.text];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (text.length) {
        [self setAttributedText:[self.text stringWithSpacing:_spacing]];
    }
}

@end
