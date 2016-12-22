//
//  Utils.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 RC. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL)isDebugBuild {
    BOOL result = NO;
#ifdef DEBUG
    result = YES;
#endif
    return result;
}

+ (CGFloat)mostThinLineWidth {
    CGFloat result = 1.0f / [UIScreen mainScreen].scale;
    return result;
}

+ (UIImage *)image:(UIImage *)image maskedByColor:(UIColor *)color
{
    UIImage *result;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    if (c) {
        [image drawInRect:rect];
        CGContextSetFillColorWithColor(c, [color CGColor]);
        CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
        CGContextFillRect(c, rect);
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return result;
}

+ (UIImage *)coloredRectImageWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 2.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, color.CGColor);
    CGContextFillRect(c, frame);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)circleImageWithRadius:(CGFloat)radius
                   backgroundColor:(UIColor *)backgroundColor
                             image:(UIImage *)image {
    CGRect rectOfCircle = CGRectMake(0.f,
                                     0.f,
                                     radius * 2,
                                     radius * 2);
    UIGraphicsBeginImageContextWithOptions(rectOfCircle.size,
                                           NO,
                                           0.f);
        CGContextRef graphicContext = UIGraphicsGetCurrentContext();
    
        CGPathRef circle = CGPathCreateWithEllipseInRect(rectOfCircle,
                                                         NULL);
        CGContextAddPath(graphicContext,
                         circle);
        CGPathRelease(circle);
    
        CGContextSetFillColorWithColor(graphicContext,
                                       backgroundColor.CGColor);
        CGContextFillPath(graphicContext);
    
        [Utils drawImage:image
              withRadius:radius];
    
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)circleImageWithRadius:(CGFloat)radius
                       borderWidth:(CGFloat)borderWidth
                       borderColor:(UIColor *)borderColor {
    CGRect rectOfResultImage = CGRectMake(0.f,
                                          0.f,
                                          radius * 2,
                                          radius * 2);
    UIGraphicsBeginImageContextWithOptions(rectOfResultImage.size,
                                           NO,
                                           0.f);
        CGContextRef graphicContext = UIGraphicsGetCurrentContext();
    
        [Utils drawCircleInContext:graphicContext
                        withRadius:radius
                       borderWidth:borderWidth
                       borderColor:borderColor];
    
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)circleImageWithRadius:(CGFloat)radius
                       borderWidth:(CGFloat)borderWidth
                       borderColor:(UIColor *)borderColor
                             image:(UIImage *)image {
    CGRect rectOfResultImage = CGRectMake(0.f,
                                          0.f,
                                          radius * 2,
                                          radius * 2);
    UIGraphicsBeginImageContextWithOptions(rectOfResultImage.size,
                                           NO,
                                           0.f);
        CGContextRef graphicContext = UIGraphicsGetCurrentContext();
    
        [Utils drawCircleInContext:graphicContext
                        withRadius:radius
                       borderWidth:borderWidth
                       borderColor:borderColor];
    
        [Utils drawImage:image
              withRadius:radius];
    
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (void)drawImage:(UIImage *)image
       withRadius:(CGFloat)radius {
    CGRect rectOfImage = CGRectMake(radius - image.size.width / 2,
                                    radius - image.size.height / 2,
                                    image.size.width,
                                    image.size.height);
    [image drawInRect:rectOfImage];
}

+ (void)drawCircleInContext:(CGContextRef)context
                withRadius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor {
    CGRect rectOfCircle = CGRectMake(borderWidth,
                                     borderWidth,
                                     (radius - borderWidth) * 2,
                                     (radius - borderWidth) * 2);
    CGPathRef circle = CGPathCreateWithEllipseInRect(rectOfCircle,
                                                     NULL);
    CGContextAddPath(context,
                     circle);
    CGPathRelease(circle);
    
    CGContextSetLineWidth(context,
                          borderWidth);
    CGContextSetStrokeColorWithColor(context,
                                     borderColor.CGColor);
    CGContextStrokePath(context);
}

+ (BOOL)isIphone4
{
    CGRect mainScreenBoundsPortrait = [Utils mainScreenBoundsPortrait];
    return ([Utils isRetina] && [Utils floatNumber:mainScreenBoundsPortrait.size.height isEqualToFloatNumber:480]);
}

+ (BOOL)isIphone5
{
    CGRect mainScreenBoundsPortrait = [Utils mainScreenBoundsPortrait];
    return ([Utils isRetina] && [Utils floatNumber:mainScreenBoundsPortrait.size.height isEqualToFloatNumber:568]);
}

+ (BOOL)floatNumber:(CGFloat)number1 isEqualToFloatNumber:(CGFloat)number2
{
    BOOL result = NO;
    CGFloat difference = ABS(number2 - number1);
    if (difference < 0.000001) {
        result = YES;
    }
    return result;
}

+ (CGRect)mainScreenBounds
{
    CGRect mainScreenBounds = [UIScreen mainScreen].bounds;
    return mainScreenBounds;
}

+ (CGRect)mainScreenBoundsPortrait
{
    CGRect result = [UIScreen mainScreen].bounds;
    if (result.size.width > result.size.height) {
        result = [Utils swapFrameSizeValues:result];
    }
    return result;
}

+ (BOOL)isRetina
{
    BOOL retina = NO;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        retina = [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    return retina;
}

+ (CGRect)swapFrameSizeValues:(CGRect)frame
{
    CGRect result = frame;
    CGFloat tempWidth = frame.size.width;
    result.size.width = frame.size.height;
    result.size.height = tempWidth;
    return result;
}

+ (BOOL)isEqualObject1:(id)obj1 toObject2:(id)obj2 {
    BOOL result;
    if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
        result = [obj1 isEqualToString:obj2];
    } else {
        result = [obj1 isEqual:obj2];
    }
    return result;
}

+ (NSInteger)randomNumberAtRangeExcludingEndWithStartNumber:(NSInteger)startNum withEndNumber:(NSInteger)endNum {
    NSInteger randomNumberAtRange = startNum + (NSInteger)arc4random() % (endNum - startNum);
    return randomNumberAtRange;
}

@end
