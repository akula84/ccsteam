//
//  NSObject+ClassName.m
//  InTouch
//
//  Created by Dmitriy Doroschuk on 04.12.15.
//  Copyright © 2015 magora-system. All rights reserved.
//

#import "NSObject+ClassName.h"

@implementation NSObject (ClassName)

+ (NSString *)rc_className {
    return NSStringFromClass([self class]);
}

- (NSString *)rc_className {
    return NSStringFromClass([self class]);
}

@end
