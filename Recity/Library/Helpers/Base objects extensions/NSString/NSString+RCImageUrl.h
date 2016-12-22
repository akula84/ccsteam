//
//  NSString+RCImageUrl.h
//  Recity
//
//  Created by ezaji.dm on 30.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RCImageSize) {
    RCImageLarge = 0,
    RCImageMedium,
    RCImageSmall,
    RCImageThumbnail
};

@interface NSString (RCImageUrl)

- (NSString *)urlStringWithImageSize:(RCImageSize)imageSize;

@end
