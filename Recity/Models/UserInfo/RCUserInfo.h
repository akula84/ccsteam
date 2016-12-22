//
//  RCUserInfo.h
//  
//
//  Created by Matveev on 11/05/16.
//
//

#import <CoreData/CoreData.h>

@class RCFavoritedProjectInfo, RCUser, RCUserNotes;

NS_ASSUME_NONNULL_BEGIN

@interface RCUserInfo : NSManagedObject;

@end

@interface RCUserInfo (Mapping)

- (void)parse:(id)data;

@end

NS_ASSUME_NONNULL_END

#import "RCUserInfo+CoreDataProperties.h"
