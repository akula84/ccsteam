//
//  RCFavoritedProjectInfo+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCFavoritedProjectInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCFavoritedProjectInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *projectUID;
@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) RCUserInfo *userinfo;

@end

NS_ASSUME_NONNULL_END
