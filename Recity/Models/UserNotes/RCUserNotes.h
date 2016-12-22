//
//  RCUserNotes.h
//  
//
//  Created by ezaji.dm on 15.07.16.
//
//

#import <Foundation/Foundation.h>
#import "RCBaseModel.h"

@class RCUserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface RCUserNotes : RCBaseModel

+ (instancetype)itemWithProject:(RCProject *)project
                      inContext:(NSManagedObjectContext *)context;
+ (instancetype)userNotesForProject:(RCProject *)project;

- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

#import "RCUserNotes+CoreDataProperties.h"
