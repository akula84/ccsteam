//
//  RCUser.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 11.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCUser : RCBaseModel

+ (PMKPromise *)authWithLogin:(NSString *)login password:(NSString *)password;

- (PMKPromise *)setProject:(RCProject *)project favoritedRemotely:(BOOL)favorited;
- (BOOL)isProjectFavoritedLocally:(RCProject *)project;
- (NSArray *)locallyFavoritedProjects;

- (PMKPromise *)downloadUserInfo;

- (void)addRecentProject:(RCProject *)project completion:(dispatch_block_t)completion;

- (void)DEBUG_simulateBadTokenCompletion:(dispatch_block_t)completion;

@end

NS_ASSUME_NONNULL_END

#import "RCUser+CoreDataProperties.h"
