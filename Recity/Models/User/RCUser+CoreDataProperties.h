//
//  RCUser+CoreDataProperties.h
//  Recity
//
//  Created by Vitaliy Zhukov on 06.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCUser.h"

NS_ASSUME_NONNULL_BEGIN

@class RCUserInfo;

@interface RCUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorizationToken;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSNumber *homeCityId;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *login;
@property (nullable, nonatomic, retain) NSString *role;
@property (nullable, nonatomic, retain) NSString *subscriptionType;
@property (nullable, nonatomic, retain) NSOrderedSet<RCBaseModel *> *recent;
@property (nullable, nonatomic, retain) RCUserInfo *userinfo;

@end

@interface RCUser (CoreDataGeneratedAccessors)

- (void)insertObject:(RCBaseModel *)value inRecentAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecentAtIndex:(NSUInteger)idx;
- (void)insertRecent:(NSArray<RCBaseModel *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecentAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecentAtIndex:(NSUInteger)idx withObject:(RCBaseModel *)value;
- (void)replaceRecentAtIndexes:(NSIndexSet *)indexes withRecent:(NSArray<RCBaseModel *> *)values;
- (void)addRecentObject:(RCBaseModel *)value;
- (void)removeRecentObject:(RCBaseModel *)value;
- (void)addRecent:(NSOrderedSet<RCBaseModel *> *)values;
- (void)removeRecent:(NSOrderedSet<RCBaseModel *> *)values;

@end

NS_ASSUME_NONNULL_END
