//
//  NSString+More.m
//  Recity
//
//  Created by Matveev on 25/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSString+More.h"

@implementation NSString (More)

- (NSAttributedString *)stringWithSpacing:(CGFloat)spacing {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:self];
    [result addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, result.length)];
    return result;
}

- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)height
{
    CGRect frame = [self rectWithFont:font size:CGSizeMake(MAXFLOAT, height)];
    return CGRectGetWidth(frame);
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width
{
    CGRect frame = [self rectWithFont:font size:CGSizeMake(width, MAXFLOAT)];
    return CGRectGetHeight(frame);
}

- (CGRect)rectWithFont:(UIFont *)font size:(CGSize)size
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName:font, NSParagraphStyleAttributeName : style};
    
    return [self boundingRectWithSize:size
                                      options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attributes
                                      context:nil];
}

@end
