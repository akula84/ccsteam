//
//  RCClusterView.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 22.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCClusterView.h"

@interface RCClusterView ()

@property (weak, nonatomic) UILabel *label;

@end

@implementation RCClusterView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 34, 34);
        
        UILabel *label = [[UILabel alloc]initWithFrame:self.frame];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        self.label = label;
        [self addSubview:label];
        
        self.backgroundColor = RGB(130,133,189);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 17;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
    }
    
    return self;
}

- (void)setCount:(NSUInteger)count
{
    NSString *text = @"";
    NSString *suffix = @"+";
    if (count > 0) {
        if (count < 5) {
            suffix = @"";
        }
        if (count >= 5 && count < 10) {
            count = 5;
        } else if (count % 10 != 0 && count > 10) {
            count = count - count % 10;
        }
        text = [NSString stringWithFormat:@"%@%@", @(count), suffix];
    }
    self.label.text = text;
}

- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
