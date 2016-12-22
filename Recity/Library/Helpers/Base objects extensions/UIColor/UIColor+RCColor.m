//
//  UIColor+RCColor.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "UIColor+RCColor.h"

#import "NSObject+Utils.h"

@implementation UIColor (RCColor)

+ (UIColor *)purpleBlueBar{
    return [self colorWithID:_cmd andRed:8 Green:29 Blue:47];
}

+ (UIColor *)purpleBlueView{
    return [self colorWithID:_cmd andRed:7 Green:34 Blue:55];
}

// Color utils
+ (UIColor *)colorWithID:(const void *)key andColor:(NSUInteger)c Alpha:(NSUInteger)alpha
{
    return [self colorWithID:key andRed:c Green:c Blue:c Alpha:alpha];
}

+ (UIColor *)colorWithID:(const void *)key andColor:(NSUInteger)c
{
    return [self colorWithID:key andRed:c Green:c Blue:c];
}

+ (UIColor *)colorWithID:(const void *)key andRed:(NSUInteger)red Green:(NSUInteger)green Blue:(NSUInteger)blue
{
    return [self colorWithID:key andRed:red Green:green Blue:blue Alpha:100];
}

+ (UIColor *)colorWithID:(const void *)key andRed:(NSUInteger)red Green:(NSUInteger)green Blue:(NSUInteger)blue Alpha:(NSUInteger)alpha
{
    UIColor *color = objc_getAssociatedObject(self, key);
    if (!color) {
        color = mColorFromRGBA_255(red, green, blue, alpha);
        objc_setAssociatedObject(self, key, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

+ (UIColor *)colorFromHEX:(NSUInteger)hex
{
    NSUInteger r = (hex & 0xFF0000) >> 16;
    NSUInteger g = (hex & 0x00FF00) >> 8;
    NSUInteger b = (hex & 0x0000FF);
    
    return mColorFromRGB_255(r, g, b);
}

+ (UIColor *)colorFromHEXString:(NSString *)hexString
{
    NSString *colorString = hexString;
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    NSScanner* hexScanner = [NSScanner scannerWithString: colorString];
    unsigned int colorHex;
    [hexScanner scanHexInt: &colorHex];
    return [self colorFromHEX:colorHex];
}


@end
