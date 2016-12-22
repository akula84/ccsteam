//
//  NSManagedObjectContext+Debug.m
//  Recity
//
//  Created by Matveev on 25/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSManagedObjectContext+Debug.h"
#import "NSManagedObject+Debug.h"

@implementation NSManagedObjectContext (Debug)

+ (void)rc_rootAndMain {
    NSLog(@"\n\n\nROOT CONTEXT model:");
    [NSManagedObjectContext printObjectsCountOfContext:[NSManagedObjectContext MR_rootSavingContext]];
    [[NSManagedObjectContext MR_rootSavingContext] rc_details];

    NSLog(@"\n\n\nROOT CONTEXT model:");
    [NSManagedObjectContext printObjectsCountOfContext:[NSManagedObjectContext MR_defaultContext]];
    [[NSManagedObjectContext MR_defaultContext] rc_details];
    NSLog(@"\n\n-------------:");
}

+ (void)printObjectsCountOfContext:(NSManagedObjectContext *)context {
    NSArray *entityDescriptions = [[[context persistentStoreCoordinator] managedObjectModel] entities];
    for (NSEntityDescription *entityDescription in entityDescriptions) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        NSError *error;
        __unused NSArray *results = [[NSManagedObjectContext MR_rootSavingContext] executeFetchRequest:request error:&error];
        NSLog(@"%@: %@",entityDescription.name, @(results.count));
    }
}

- (void)rc_details {
//    [self rc_deletedObjects];
//    [self rc_insertedObjects];
//    [self rc_changedObjects];

    //      unprocessed deletes
    //      unprocessed inserts
    //      unprocessed changes

    //      locked objects
    //      refreshed objects
}

- (void)rc_insertedObjects {
    NSLog(@"\n\n%@ INSERTED OBJECTS:  %@",[self nameOfContext],@(self.insertedObjects.count));
    for (NSManagedObject *object in self.insertedObjects) {
        [object rc_logFields];
    }
}

- (void)rc_deletedObjects {
    NSLog(@"\n\n%@ DELETED OBJECTS:  %@",[self nameOfContext], @(self.deletedObjects.count));
    for (NSManagedObject *object in self.deletedObjects) {
        [object rc_logFields];
    }
}

- (void)rc_changedObjects {
    NSLog(@"\n\n%@ UPDATED OBJECTS:  %@",[self nameOfContext], @(self.updatedObjects.count));
    for (NSManagedObject *object in self.updatedObjects) {
        [object rc_logFields];
    }
}

- (NSString *)nameOfContext {
    NSString *result;
    if ([[NSManagedObjectContext MR_rootSavingContext] isEqual:self]) {
        result = @"ROOT CONTEXT";
    }
    if ([[NSManagedObjectContext MR_defaultContext] isEqual:self]) {
        result = @"GUI CONTEXT";
    }
    return result;
}

@end
