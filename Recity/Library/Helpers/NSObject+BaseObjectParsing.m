//
//  NSObject+BaseObjectParsing.m
//  Dishero
//
//  Created by Alexander Kozin on 18.07.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//

#import "NSObject+BaseObjectParsing.h"

#import "AWModel.h"

#import "NSString+AWUtils.h"

@implementation NSObject (BaseObjectParsing)

- (id)aw_parseTo:(Class)class
{
    NSLog(@"%@ is not object to parse", self);

    return nil;
}

- (NSString *)aw_modelClassNameForKey:(NSString *)key
{
    return @"";
}

- (id)aw_valueForAPI:(SEL)selector
{
    return self;
}

@end

@implementation AWModel (BaseObjectParsing)

- (id)aw_valueForAPI:(SEL)selector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:selector];
#pragma clang diagnostic pop
}

@end

@implementation NSArray (BaseObjectParsing)

- (id)aw_parseTo:(Class)class
{
    return [class objectsFromArray:self];
}

- (NSString *)aw_modelClassNameForKey:(NSString *)key
{
    // Remove 's' for arrays
    NSString *className = [key substringToIndex:key.length - 1];
    className = [className classNameFromBackendKey];

    return className;
}

- (id)aw_valueForAPI:(SEL)selector
{
    NSMutableArray *valueForAPI = [NSMutableArray arrayWithCapacity:self.count];

    for (id object in self) {
        [valueForAPI addObject:[object aw_valueForAPI:selector]];
    }

    return valueForAPI;
}

@end

@implementation NSDictionary (BaseObjectParsing)

- (id)aw_parseTo:(Class)class
{
    return [class objectFromDictionary:self];
}

- (NSString *)aw_modelClassNameForKey:(NSString *)key
{
    NSString *className = [key classNameFromBackendKey];

    return className;
}

- (id)aw_valueForAPI:(SEL)selector
{
    NSMutableDictionary *valueForAPI = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        valueForAPI[key] = [obj aw_valueForAPI:selector];
    }];

    return valueForAPI;
}

@end
