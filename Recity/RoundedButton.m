//
//  RoundedRectButton.m
//  golf-fitness
//
//  Created by Andrey Marshak on 7/1/16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (void)awakeFromNib {
    self.radius = 4.0;
    self.clipsToBounds = YES;
    UIImage *img = [Utils coloredRectImageWithFrame:CGRectMake(0,0,1,1) withColor:kLightedDarkPurpleColor];
    [self setBackgroundImage:img forState:UIControlStateHighlighted];
    [self setBackgroundImage:img forState:UIControlStateSelected];
    UIImage *disabledImg = [Utils coloredRectImageWithFrame:CGRectMake(0,0,1,1) withColor:kDisabledButtonPurpleColor];
    [self setBackgroundImage:disabledImg forState:UIControlStateDisabled];
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.layer.cornerRadius = _radius;
    [self setNeedsDisplay];
}

@end
