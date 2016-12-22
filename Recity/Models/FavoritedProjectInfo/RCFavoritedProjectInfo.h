//
//  RCFavoritedProjectInfo.h
//  
//
//  Created by Matveev on 10/05/16.
//
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class RCAddress;

@interface RCFavoritedProjectInfo : RCBaseModel

+ (instancetype)itemWith:(id)model inContext:(NSManagedObjectContext *)context;
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

#import "RCFavoritedProjectInfo+CoreDataProperties.h"
