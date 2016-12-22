//
//  NSManagedObjectContext+Debug.h
//  Recity
//
//  Created by Matveev on 25/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Debug)

+ (void)rc_rootAndMain;

- (void)rc_details;
- (void)rc_insertedObjects;
- (void)rc_deletedObjects;
- (void)rc_changedObjects;

@end
