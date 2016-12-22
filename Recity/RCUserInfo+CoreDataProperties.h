//
//  RCUserInfo+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCUserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) RCUser *user;
@property (nullable, nonatomic, retain) NSSet<RCFavoritedProjectInfo *> *favoritedProjectInfos;

@end

@interface RCUserInfo (CoreDataGeneratedAccessors)

- (void)addFavoritedProjectInfosObject:(RCFavoritedProjectInfo *)value;
- (void)removeFavoritedProjectInfosObject:(RCFavoritedProjectInfo *)value;
- (void)addFavoritedProjectInfos:(NSSet<RCFavoritedProjectInfo *> *)values;
- (void)removeFavoritedProjectInfos:(NSSet<RCFavoritedProjectInfo *> *)values;

@end

NS_ASSUME_NONNULL_END
