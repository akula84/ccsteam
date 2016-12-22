//
//  DSBaseObject.h
//  Dishero
//
//  Created by Alexander Kozin on 16.04.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//


@import Foundation;

#import "AWSettings.h"

@interface AWModel (DictionaryToObject)

/**
 *  Parses API reply
 *  Calls objectsFromArray: for arrays and objectFromDictionary: for dictionaries
 *
 *  @param reply Reply from API to parse
 *
 *  @return Parsed object or array of objects
 */
+ (id)objectFromReply:(id)reply;

/**
 *  Parses array of objects
 *  Calls objectFromDictionary: iteratively
 *
 *  @param source Array of dictionaries that represent an object
 *
 *  @return Array of parsed objects
 */
+ (NSArray *)objectsFromArray:(NSArray*)source;

/**
 *  Parses object with property values filled according to dictionary
 *
 *  @param source Source dictionary which represents object
 *
 *  @return Parsed object
 */
+ (instancetype)objectFromDictionary:(NSDictionary*)source;

- (BOOL)safelySetValue:(id)value forKey:(NSString *)key;

@end

@interface AWModel (Mapping)

+ (NSDictionary *)mapProperties;
+ (NSDictionary *)mapClasses;

+ (void)mapPropertyFrom:(NSString *)from to:(NSString *)to;
+ (NSString *)mappingForProperty:(NSString *)propertyName;
+ (NSString *)propertyForMapping:(NSString *)mapping;

+ (void)mapClassFrom:(NSString *)from to:(NSString *)to;
+ (NSString *)mappingForClass:(NSString *)className;

@end

@interface AWModel (ObjectToDictionary)

- (NSMutableDictionary*)fullObject;
- (NSMutableDictionary*)simpleObject;
- (NSMutableDictionary*)identifierObject;

- (NSMutableDictionary *)objectForKeys:(NSArray *)keys;

//- (NSString *)allObjectKeysWithSuper:(BOOL)withSuper;
//- (NSMutableDictionary *)allObjectPropertiesWithSuper:(BOOL)withSuper;

@end
