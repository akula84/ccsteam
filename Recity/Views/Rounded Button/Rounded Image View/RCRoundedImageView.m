//
//  RCRoundedImageView.m
//  Recity
//
//  Created by ezaji.dm on 13.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCRoundedImageView.h"

@implementation RCRoundedImageView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = YES;
    [self setNeedsDisplay];
}

- (void)setImageName:(NSString *)imageName
{
    if([imageName isEqualToString:@"will_add_suggestion"]) {
        [self setupBorder];
    } else if([imageName isEqualToString:@"confirm_suggestion"] ||
              [imageName isEqualToString:@"add_suggestion"] ||
              [imageName isEqualToString:@"reject_suggestion"]) {
        [self setupBackground];
    }
    
    self.image = IMG(imageName);
    
    if([imageName isEqualToString:@"none_suggestion"]) {
        [self setupBorder];
        self.image = nil;
    }
}

- (void)setupBorder
{
    self.layer.borderWidth = 1.25f;
    self.layer.borderColor = RGB(125, 125, 125).CGColor;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupBackground
{
    self.layer.borderWidth = 0.f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundColor = RGB(46, 49, 146);
}

@end
