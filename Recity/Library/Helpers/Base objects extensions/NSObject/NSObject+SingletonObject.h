//
//  NSObject+SingletonObject.m
//
//  Created by Alexander Kozin on 24/01/14.
//

@import Foundation;

#import "AppProtection.h"

#define SINGLETON_OBJECT \
+ (instancetype)shared \
{ \
    SEC_IS_BEING_DEBUGGED_RETURN_NIL(); \
    static id shared;\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared = [self new]; \
        [shared prepareSingleton]; \
    }); \
    return shared; \
}

@interface NSObject (SingletonObject)

+ (instancetype)shared;

- (void)prepareSingleton;

@end
