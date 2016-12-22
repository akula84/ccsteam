//
//  RCParseController.m
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCParseHelper.h"

#import "RCBaseModel.h"

@implementation RCParseHelper

+ (void)parseSaveArray:(id)data aClass:(Class)aClass completion:(complete)completion
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_context];
    [backgroundContext performBlock:^{
        NSArray *array = [self parseArray:data aClass:aClass inContext:backgroundContext];
        [backgroundContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            completion([self copyArray:array]);
         }];
    }];
}

+ (NSArray *)parseArray:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context
{
    NSMutableArray *array = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        [array addObject:[self parseObject:item aClass:aClass inContext:context]];
    }];
    return [NSArray arrayWithArray:array];
}

+ (id)parseObject:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context
{
    RCBaseModel *obj = [self createObjIsNeed:data aClass:aClass inContext:context];
    [obj MR_importValuesForKeysWithObject:data];
    return obj;
}

+ (id)createObjIsNeed:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context
{
    NSString *entityId = data[kId];
    RCBaseModel *obj = [aClass MR_findFirstByAttribute:kUid withValue:entityId inContext:context];
    if (!obj) {
        obj = [aClass MR_createEntityInContext:context];
    }
    return obj;
}

+ (NSArray *)copyArray:(NSArray *)originalArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSManagedObject *entity in originalArray) {
        [array addObject:[self copyObject:entity]];
    }
    return array;
}

+ (id)copyObject:(NSManagedObject *)entity
{
    return [self copyObject:entity inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (id)copyObject:(NSManagedObject *)entity inContext:(NSManagedObjectContext *)context
{
    return [context objectWithID: entity.objectID];
}

@end
