//
//  NSManagedObject+More.m
//  golf-fitness
//
//  Created by Matveev on 24.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "NSManagedObject+More.h"

@implementation NSManagedObject (More)

+ (instancetype)rc_createFromDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context {
    //      you should rewrite this method in subclasses
    return nil;
}

+ (id)rc_firstObjectWithUID:(id)uid {
    id result;
    ASSERT(uid);
    NSArray *objectsWithSameUID = [self rc_objectsWithUIDs:@[uid]];
    if (objectsWithSameUID.count > 0) {
        result = objectsWithSameUID[0];
    }
    return result;
}

+ (id)rc_firstObjectWithUID:(id)uid inContext:(NSManagedObjectContext *)context {
    id result;
    ASSERT(uid);
    NSArray *objectsWithSameUID = [self rc_objectsWithUIDs:@[uid] inContext:context];
    if (objectsWithSameUID.count > 0) {
        result = objectsWithSameUID[0];
    }
    return result;
}

+ (NSArray *)rc_objectsWithUIDs:(NSArray *)UIDs {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSNumber *currentUID in UIDs) {
        id item = [[self class] MR_findFirstByAttribute:@"uid" withValue:currentUID];
        if (item) {
            [result addObject:item];
        }
    }
    return result;
}

+ (NSArray *)rc_objectsWithUIDs:(NSArray *)UIDs inContext:(NSManagedObjectContext *)context {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSNumber *currentUID in UIDs) {
        id item = [[self class] MR_findFirstByAttribute:@"uid" withValue:currentUID inContext:context];
        if (item) {
            [result addObject:item];
        }
    }
    return result;
}

+ (NSArray *)rc_UIDsOfObjectsCreatedFromArrayOfDicts:(NSArray *)array inContext:(NSManagedObjectContext *)context {
    NSArray *result;
    NSMutableArray *items = [@[] mutableCopy];
    for (NSDictionary *currentDict in array) {
        id item = [[self class] rc_createFromDictionary:currentDict inContext:context];
        [items addObject:item];
    }
    result = [items valueForKey:@"uid"];
    return result;
}


+ (NSArray *)rc_objectsWithValues:(NSArray *)values ofFieldName:(NSString *)fieldName inContext:(NSManagedObjectContext *)context {
    NSMutableArray *result = [@[] mutableCopy];
    for (NSNumber *currentValue in values) {
        id item = [[self class] MR_findFirstByAttribute:fieldName withValue:currentValue inContext:context];
        if (item) {
            [result addObject:item];
        }
    }
    return result;
}

@end
