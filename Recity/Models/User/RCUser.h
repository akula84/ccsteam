//
//  RCUser.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 11.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseModel.h"

@class RCUserNotes;

NS_ASSUME_NONNULL_BEGIN

@interface RCUser : RCBaseModel

- (BOOL)hasAdvancedSubscription;

@end

@interface RCUser (Recent)

- (void)addRecentItem:(id)item completion:(dispatch_block_t)completion;

@end

@interface RCUser (Favorit)

- (void)setItem:(id)item favoritedRemotely:(BOOL)favorited;
- (BOOL)isItemFavoritedLocally:(id)item;
- (NSArray *)locallyFavoritedItems;

@end

FOUNDATION_EXPORT NSString *const RCUserNotesDidUpdateNotification;

@interface RCUser (UserNotes)

- (void)setNotesWithText:(NSString *)text
              forProject:(RCProject *)project;
- (void)deleteNotes:(RCUserNotes *)userNotes;

@end

NS_ASSUME_NONNULL_END

#import "RCUser+CoreDataProperties.h"
