//
//  AnnotationAddress.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAnnotationAddress.h"

#import "RCAddress.h"
#import "RCSearchManager.h"

@interface RCAnnotationAddress()

@property (assign, nonatomic) CLLocationCoordinate2D searchCoordinate;

@end

@implementation RCAnnotationAddress

+ (instancetype)itemWithAddress:(RCAddress *)address
{
    RCAnnotationAddress *item = [RCAnnotationAddress new];
    item.coordinate = address.coordinate;
    item.address = address;
    
    item.searchCoordinate = item.coordinate;
    return item;
}

- (UIImage *)image
{
    NSString *name = @"star_orange";
    if ([self isSelected]||[self isSearch]) {
        name = @"pinAddress";
    }
    return IMG(name);
}

- (BOOL)isSelected
{
    return [self.address isSelected];
}

- (BOOL)isSearch
{
    BOOL isSearch = [self isEqualAddress:[RCSearchManager resultItem]];
    if (![RCSearchManager shared].showResultAddressInMap) {
        isSearch = NO;
    }
    return isSearch;
}

- (BOOL)isEqualAddress:(RCAddress *)address
{
    if (![address isKindOfClass:[RCAddress class]]) {
        return NO;
    }
    return [address isEqualAddress:self.address];
}

@end
