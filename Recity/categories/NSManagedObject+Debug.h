//
//  NSManagedObject+Debug.h
//  Recity
//
//  Created by Matveev on 25/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Debug)

- (void)rc_logFields;

+ (NSArray *)rc_logAllInRootContext;
+ (NSArray *)rc_logAllInMainContext;

+ (void)rc_logFieldsOfAllInRootContext;
+ (void)rc_logFieldsOfAllInMainContext;

@end
