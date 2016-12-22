//
//  RCUserInfo.m
//  
//
//  Created by Matveev on 11/05/16.
//
//

#import "RCUserInfo.h"

@implementation RCUserInfo

- (void)addFavoritedProjectInfosObject:(RCFavoritedProjectInfo *)value
{
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.favoritedProjectInfos];
    [newSet addObject:value];
    self.favoritedProjectInfos = newSet;
}

- (void)removeFavoritedProjectInfosObject:(RCFavoritedProjectInfo *)value
{
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.favoritedProjectInfos];
    [newSet removeObject:value];
    self.favoritedProjectInfos = newSet;
}

- (void)addUserNotesObject:(RCUserNotes *)value {
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.userNotes];
    [newSet addObject:value];
    self.userNotes = newSet;
}

- (void)removeUserNotesObject:(RCUserNotes *)value {
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.userNotes];
    [newSet removeObject:value];
    self.userNotes = newSet;
}

@end
