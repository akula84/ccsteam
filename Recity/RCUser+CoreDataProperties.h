//
//  RCUser+CoreDataProperties.h
//  
//
//  Created by Matveev on 11/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCUser.h"
#import "RCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorizationToken;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *login;
@property (nullable, nonatomic, retain) NSString *role;
@property (nullable, nonatomic, retain) NSOrderedSet<RCProject *> *recentProjects;
@property (nullable, nonatomic, retain) RCUserInfo *userinfo;

@end

@interface RCUser (CoreDataGeneratedAccessors)

- (void)insertObject:(RCProject *)value inRecentProjectsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecentProjectsAtIndex:(NSUInteger)idx;
- (void)insertRecentProjects:(NSArray<RCProject *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecentProjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecentProjectsAtIndex:(NSUInteger)idx withObject:(RCProject *)value;
- (void)replaceRecentProjectsAtIndexes:(NSIndexSet *)indexes withRecentProjects:(NSArray<RCProject *> *)values;
- (void)addRecentProjectsObject:(RCProject *)value;
- (void)removeRecentProjectsObject:(RCProject *)value;
- (void)addRecentProjects:(NSOrderedSet<RCProject *> *)values;
- (void)removeRecentProjects:(NSOrderedSet<RCProject *> *)values;

@end

NS_ASSUME_NONNULL_END
