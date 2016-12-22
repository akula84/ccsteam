//
//  AWModel+Mapping.m
//  
//
//  Created by Alexander Kozin on 11.07.15.
//
//

#import "AWModel.h"

@import ObjectiveC.runtime;

@implementation AWModel (Mapping)

+ (NSMutableDictionary *)propertyMapping
{
    NSMutableDictionary *mapping = objc_getAssociatedObject(self, _cmd);
    if (!mapping) {
        mapping = [NSMutableDictionary dictionaryWithDictionary:@{@"id": @"uid",
                                                                  @"description": @"content"}];
        [mapping addEntriesFromDictionary:[self mapProperties]];

        objc_setAssociatedObject(self, _cmd, mapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mapping;
}

+ (NSDictionary *)mapProperties
{
    return nil;
}

+ (NSMutableDictionary *)classMapping
{
    NSMutableDictionary *mapping = objc_getAssociatedObject(self, _cmd);
    if (!mapping) {
        mapping = [NSMutableDictionary dictionary];
        [mapping addEntriesFromDictionary:[self mapClasses]];

        objc_setAssociatedObject(self, _cmd, mapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mapping;
}

+ (NSDictionary *)mapClasses
{
    return nil;
}

+ (void)drainMappings
{
    objc_setAssociatedObject(self, @selector(propertyMapping), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(classMapping), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)mapPropertyFrom:(NSString *)from to:(NSString *)to
{
    [self propertyMapping][from] = to;
}

+ (NSString *)mappingForProperty:(NSString *)propertyName
{
    return [self propertyMapping][propertyName];
}

+ (NSString *)propertyForMapping:(NSString *)mapping
{
    return [[[self propertyMapping] allKeysForObject:mapping] firstObject];
}

+ (void)mapClassFrom:(NSString *)from to:(NSString *)to
{
    [self classMapping][from] = to;
}

+ (NSString *)mappingForClass:(NSString *)className
{
    return [self classMapping][className];
}

@end
