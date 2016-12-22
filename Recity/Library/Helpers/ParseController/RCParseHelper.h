//
//  RCParseController.h
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//
@interface RCParseHelper : NSObject

typedef void (^complete) (NSArray *array);
+ (void)parseSaveArray:(id)data aClass:(Class)aClass completion:(complete)completion;
+ (NSArray *)parseArray:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context;
+ (id)parseObject:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context;
+ (NSArray *)copyArray:(NSArray *)originalArray;
+ (id)copyObject:(NSManagedObject *)entity;
+ (id)copyObject:(NSManagedObject *)entity inContext:(NSManagedObjectContext *)context;
+ (id)createObjIsNeed:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context;

@end
