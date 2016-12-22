//
//  RCUserInfo+CoreDataProperties.h
//  Recity
//
//  Created by Vitaliy Zhukov on 16.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RCUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCUserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSOrderedSet <RCFavoritedProjectInfo *> *favoritedProjectInfos;
@property (nullable, nonatomic, retain) NSOrderedSet <RCUserNotes *> *userNotes;
@property (nullable, nonatomic, retain) RCUser *user;

@end

@interface RCUserInfo (CoreDataGeneratedAccessors)

- (void)insertObject:(RCFavoritedProjectInfo *)value inFavoritedProjectInfosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFavoritedProjectInfosAtIndex:(NSUInteger)idx;
- (void)insertFavoritedProjectInfos:(NSArray<RCFavoritedProjectInfo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFavoritedProjectInfosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFavoritedProjectInfosAtIndex:(NSUInteger)idx withObject:(RCFavoritedProjectInfo *)value;
- (void)replaceFavoritedProjectInfosAtIndexes:(NSIndexSet *)indexes withFavoritedProjectInfos:(NSArray<RCFavoritedProjectInfo *> *)values;
- (void)addFavoritedProjectInfosObject:(RCFavoritedProjectInfo *)value;
- (void)removeFavoritedProjectInfosObject:(RCFavoritedProjectInfo *)value;
- (void)addFavoritedProjectInfos:(NSOrderedSet<RCFavoritedProjectInfo *> *)values;
- (void)removeFavoritedProjectInfos:(NSOrderedSet<RCFavoritedProjectInfo *> *)values;

- (void)insertObject:(RCUserNotes *)value inUserNotesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUserNotesAtIndex:(NSUInteger)idx;
- (void)insertUserNotes:(NSArray<RCUserNotes *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUserNotesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUserNotesAtIndex:(NSUInteger)idx withObject:(RCUserNotes *)value;
- (void)replaceUserNotesAtIndexes:(NSIndexSet *)indexes withUserNotes:(NSArray<RCUserNotes *> *)values;
- (void)addUserNotesObject:(RCUserNotes *)value;
- (void)removeUserNotesObject:(RCUserNotes *)value;
- (void)addUserNotes:(NSOrderedSet<RCUserNotes *> *)values;
- (void)removeUserNotes:(NSOrderedSet<RCUserNotes *> *)values;

@end

NS_ASSUME_NONNULL_END
