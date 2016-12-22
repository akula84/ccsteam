//
//  BaseDataObject+ObjectToDictionary.m
//  Dishero
//
//  Created by Alexander Kozin on 16.04.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//

#import "AWModel.h"

#import "NSString+AWUtils.h"
#import "NSObject+BaseObjectParsing.h"

#import <isFull.h>

@import ObjectiveC.runtime;

@implementation AWModel (ObjectToDictionary)

- (NSMutableDictionary*)fullObject
{
    return nil;//[self allObjectPropertiesWithSuper:YES];
}

- (NSMutableDictionary*)simpleObject
{
    return [self identifierObject];
}

- (NSMutableDictionary *)identifierObject
{
    NSMutableDictionary *fullObject;
    fullObject = [NSMutableDictionary dictionary];
//    fullObject = [self generateDictionaryForBindings:NSDictionaryOfVariableBindings(@(_uid)];

    return fullObject;
}

- (NSMutableDictionary *)objectForKeys:(NSArray *)keys
{
    Class class = [self class];

    NSMutableDictionary *object = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    for (NSString *key in keys) {
        id value = [self valueForKey:key];

        // Look for mapping first
        NSString *backendKey = [class propertyForMapping:key];
        // If can't find
        if (!backendKey) {
            // Convert key
            backendKey = [key backendKeyFromPropertyName];
            // And save it to mapping
            [class mapPropertyFrom:backendKey to:key];
        }

        // Object should return it's value for sending to API
        // If this is a model, it would be converted to object internally
        id valueForAPI = [value aw_valueForAPI:@selector(fullObject)];

        [object setValue:valueForAPI forKey:backendKey];
    }

    return object;
}

//- (NSString *)allObjectKeysWithSuper:(BOOL)withSuper
//{
//    NSDictionary *allProperties = [self allObjectPropertiesWithSuper:withSuper];
//    NSMutableString *string = [NSMutableString new];
//    [string appendString:@"@["];
//
//    for (NSString *key in allProperties.allKeys) {
//        [string appendFormat:@"@\"%@\", ", key];
//    }
//
//    NSRange range = NSMakeRange(string.length - 2, 2);
//    [string replaceCharactersInRange:range withString:@"]"];
//
//    return string;
//}
//
//- (NSMutableDictionary *)allObjectPropertiesWithSuper:(BOOL)withSuper
//{
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//
//    Class class = [self class];
//    Class nsObjectClass = [NSObject class];
//
//    if (withSuper) {
//        while (class != nsObjectClass) {
//            [dictionary addEntriesFromDictionary:[self valuesForPropertiesOfClass:class]];
//            class = [class superclass];
//        }
//    } else {
//        [dictionary addEntriesFromDictionary:[self valuesForPropertiesOfClass:class]];
//    }
//
//    return dictionary;
//}
//
//- (NSMutableDictionary *)valuesForPropertiesOfClass:(Class)class
//{
//    NSMutableDictionary *dictionary;
//
//    unsigned int propertiesCount;
//    objc_property_t *properties = class_copyPropertyList(class, &propertiesCount);
//
//    dictionary = [self valuesForProperties:properties withCount:propertiesCount];
//
//    if (properties) {
//        free(properties);
//    }
//
//    return dictionary;
//}
//
//- (NSMutableDictionary *)valuesForProperties:(objc_property_t *)properties withCount:(unsigned int)count
//{
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//
//    for (NSUInteger i = 0; i < count; i++) {
//        objc_property_t currentPropertie = properties[i];
//        NSString *objectKey = [NSString stringWithUTF8String:property_getName(currentPropertie)];
//        NSString *apiKey = objectKey;
//        
//        id value = [[self valueForKey:objectKey] aw_valueForAPI:@selector(allObjectPropertiesWithSuper)];
//
//        if ([value isFull]) {
//            dictionary[apiKey] = value;
//        }
//    }
//
//    return dictionary;
//}

@end
