//
//  NSManagedObject+More.h
//  golf-fitness
//
//  Created by Matveev on 24.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (More)

+ (instancetype)rc_createFromDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;//      you should rewrite this method in subclasses

+ (id)rc_firstObjectWithUID:(id)uid;
+ (id)rc_firstObjectWithUID:(id)uid inContext:(NSManagedObjectContext *)context;
+ (NSArray *)rc_objectsWithUIDs:(NSArray *)UIDs;
+ (NSArray *)rc_objectsWithUIDs:(NSArray *)UIDs inContext:(NSManagedObjectContext *)context;
+ (NSArray *)rc_UIDsOfObjectsCreatedFromArrayOfDicts:(NSArray *)array inContext:(NSManagedObjectContext *)context;

+ (NSArray *)rc_objectsWithValues:(NSArray *)values ofFieldName:(NSString *)fieldName inContext:(NSManagedObjectContext *)context;

@end
