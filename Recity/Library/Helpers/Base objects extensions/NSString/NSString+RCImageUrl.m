//
//  NSString+RCImageUrl.m
//  Recity
//
//  Created by ezaji.dm on 30.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSString+RCImageUrl.h"

@implementation NSString (RCImageUrl)

- (NSString *)urlStringWithImageSize:(RCImageSize)imageSize
{
    NSString *appendedString = nil;
    switch (imageSize) {
        case RCImageLarge:
            appendedString = @"_large";
            break;
        case RCImageMedium:
            appendedString = @"_medium";
            break;
        case RCImageSmall:
            appendedString = @"_small";
            break;
        case RCImageThumbnail:
            appendedString = @"_thumbnail";
    }
    return [self stringByAppendingString:appendedString];
}

@end
