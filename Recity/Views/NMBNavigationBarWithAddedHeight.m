//
//  NMBPaymentNavigationBar.m
//  neemble
//
//  Created by Vitaliy Zhukov on 20.10.15.
//  Copyright © 2015 El-Machine. All rights reserved.
//

#import "NMBNavigationBarWithAddedHeight.h"

#import "UIFont+RecityFont.h"
#import "UIColor+RCColor.h"

@implementation NMBNavigationBarWithAddedHeight

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += self.addedHeight;
    [self setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor purpleRCColor],
       NSFontAttributeName: [UIFont flamaBook13]}];
    return amendedSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    for (UIView *view in [self subviews]) {
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y = bounds.origin.y + self.addedHeight - 20.f;
            frame.size.height = bounds.size.height + 20.f;
            [view setFrame:frame];
        }
    }
}

@end
