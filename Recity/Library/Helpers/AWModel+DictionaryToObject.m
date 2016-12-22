//
//  BaseDataObject+Parsing.m
//  Dishero
//
//  Created by Alexander Kozin on 16.04.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//

#import "AWModel.h"

#import "NSObject+BaseObjectParsing.h"
#import "NSString+AWUtils.h"

#import <isFull.h>

@implementation AWModel (DictionaryToObject)

//+ (id)objectFromReply:(id)reply
//{
//    id object = nil;
//    if ([reply isFull]) {
//        if ([reply isKindOfClass:[NSArray class]])
//            object = [self objectsFromArray:reply];
//        else if ([reply isKindOfClass:[NSDictionary class]])
//            object = [self objectFromDictionary:reply];
//    }
//    
//    return object;
//}
//
//+ (id)objectsFromArray:(NSArray*)source
//{
//    NSMutableArray *parsedObjects = [NSMutableArray arrayWithCapacity:source.count];
//    for (NSDictionary *object in source) {
//        if ([object isKindOfClass:[NSDictionary class]]) {
//            id parsedObject = [self objectFromDictionary:object];
//            [parsedObjects addObject:parsedObject];
//        }
//    }
//    
//    return parsedObjects;
//}

+ (id)objectFromReply:(id)reply
{
    id object = [reply aw_parseTo:self];
    return object;
}

+ (id)objectsFromArray:(NSArray*)source
{
    NSMutableArray *parsedObjects = [NSMutableArray arrayWithCapacity:source.count];
    for (NSDictionary *object in source) {
        id parsedObject = [object aw_parseTo:self];
        [parsedObjects addObject:parsedObject];
    }

    return parsedObjects;
}

+ (instancetype)objectFromDictionary:(NSDictionary*)source
{
    AWModel *object = nil;
    if ([source isFull]) {
        object = [self new];

        [source enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            // If object contains data
            if ([key isFull] && [value isFull]) {
                [object parseObject:value forKey:key];
            }
        }];
    }

    return object;
}

- (void)parseObject:(id)source forKey:(NSString*)key
{
    id objectToSet = source;

    Class class = [self class];

    // Try to find property name in mapping first
    NSString *propertyName = [class mappingForProperty:key];
    // If can't find
    if (![propertyName isFull]) {
        // Convert key to property name
        propertyName = [key propertyFromBackendKey];
        // And save it to mapping
        [class mapPropertyFrom:key to:propertyName];
    }

    // Try to convert key to model class
    // Try to find class in mapping first
    NSString *modelClassName = [class mappingForClass:key];
    // If can't find
    if (!modelClassName) {
        // Convert key to class name
        modelClassName = [source aw_modelClassNameForKey:key];
        // And save it to mapping
        // Don't care it's class or not, just cache it to prevent converting again
        [class mapClassFrom:key to:modelClassName];
    }

    Class modelClass = NSClassFromString(modelClassName);
    // If class exist, parse value to model
    if (modelClass) {
        objectToSet = [modelClass objectFromReply:source];
    }

    // And set value (parsed or not) to property
    [self safelySetValue:objectToSet forKey:propertyName];
}

- (BOOL)safelySetValue:(id)value forKey:(NSString *)key
{
    SEL selector = NSSelectorFromString(key);
    Class class = [self class];
    BOOL can = [class resolveInstanceMethod:selector];
    if (!can) {
        id whoCan = [self forwardingTargetForSelector:selector];
        if (whoCan) {
            can = [whoCan resolveInstanceMethod:selector];
        }
    }
//    if (can) {
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        [self setValue:value forKey:key];
    }

    return can;
}

@end
