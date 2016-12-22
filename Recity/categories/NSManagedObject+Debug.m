//
//  NSManagedObject+Debug.m
//  Recity
//
//  Created by Matveev on 25/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSManagedObject+Debug.h"

@implementation NSManagedObject (Debug)

- (void)rc_logFields {
    NSEntityDescription *entity = [self entity];
    NSDictionary *attributes = [entity attributesByName];
    for (NSString *attribute in attributes) {
        __unused id value = [self valueForKey: attribute];
        NSLog(@"%@ = %@", attribute, value);
    }
}

+ (NSArray *)rc_logAllInRootContext {
    NSArray *result = [[self class] MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]];
    return result;
}

+ (NSArray *)rc_logAllInMainContext {
    NSArray *result = [[self class] MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    return result;
}

+ (void)rc_logFieldsOfAllInRootContext {
    NSArray *objects = [[self class] rc_logAllInRootContext];
    NSLog(@"\n\n%@ root context count %@",[self rc_className],@(objects.count))
    for (NSInteger i = 0; i < objects.count; ++i) {
        NSManagedObject *object = objects[i];
        NSLog(@"object %@:",@(i));
        [object rc_logFields];
        NSLog(@"");
    }
}

+ (void)rc_logFieldsOfAllInMainContext {
    NSArray *objects = [[self class] rc_logAllInMainContext];
    NSLog(@"\n\n%@ main context count %@",[self rc_className],@(objects.count))
    for (NSInteger i = 0; i < objects.count; ++i) {
        NSManagedObject *object = objects[i];
        NSLog(@"object %@:",@(i));
        [object rc_logFields];
        NSLog(@"");
    }
}

@end
