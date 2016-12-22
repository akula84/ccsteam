//
//  RCUser+Favorit.m
//  Recity
//
//  Created by Artem Kulagin on 21.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUser.h"

#import "RCUserInfo.h"
#import "RCProject.h"
#import "RCAddress.h"
#import "RCFavoritedProjectInfo.h"
#import "RCAddFavoriteAPI.h"
#import "RCRemoveFavoriteAPI.h"
#import "RCPredicateFactory.h"

@implementation RCUser (Favorit)

- (void)setItem:(id)item favoritedRemotely:(BOOL)favorited
{
    RCFavoritedProjectInfo *info = [self infoFromItem:item];
    if (favorited) {
        if (!info) {
            RCUserInfo *userinfo = self.userinfo;
            NSManagedObjectContext *managedObjectContext = [userinfo managedObjectContext];
            info = [RCFavoritedProjectInfo itemWith:item inContext:managedObjectContext];
            [userinfo addFavoritedProjectInfosObject:info];
        }
        [self sendAddFavorites:info obj:item];
        
    } else {
        if (info.uid) {
            [self.userinfo removeFavoritedProjectInfosObject:info];
            [info MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
            
            [RCRemoveFavoriteAPI withObject:@{kId: info.uid} completion:nil];
            [self postNotification:item];
        } else {
            NSLog(@"BAD RCFavoritedProjectInfo uid %@",info);
        }
    }
    
    [self sendItemForAnalyst:(id)item
           favoritedRemotely:(BOOL)favorited];
}

- (void)sendItemForAnalyst:(id)item
         favoritedRemotely:(BOOL)favorited
{
    NSString *category = nil;
    NSString *action = nil;
    NSString *label = nil;
    if ([item isKindOfClass:[RCProject class]]) {
        category = RCDevelopmentDetailsCategory;
        action = RCDevelopmentDetailsFavoriteAction;
        label = ((RCProject *)item).name;
    } else if ([item isKindOfClass:[RCAddress class]]) {
        category = RCDevelopmentIndexCategory;
        action = RCDevelopmentIndexFavoriteAction;
        label = ((RCAddress *)item).address;
    }
    NSNumber *value = favorited ? @(1) : @(0);
    if(category && action && label) {
        [[RCAnalyticsServicesComposite sharedInstance] trackEventWithCategory:category
                                                                       action:action
                                                                        label:label
                                                                        value:value];
    }
}

- (void)sendAddFavorites:(RCFavoritedProjectInfo *)info obj:(id)obj
{
    [RCAddFavoriteAPI withObject:[info dictionary]  completion:^(id reply, NSError *error, BOOL *handleError) {
        info.uid = reply;
        [[self.userinfo managedObjectContext] MR_saveOnlySelfWithCompletion:nil];
        [self postNotification:obj];
    }];
}

- (RCFavoritedProjectInfo *)infoFromItem:(id)item
{
    RCFavoritedProjectInfo *info;
    if ([item isKindOfClass:[RCProject class]]) {
        RCProject *project = (RCProject *)item;
        info = [RCFavoritedProjectInfo MR_findFirstByAttribute:@"projectUID" withValue:project.uid inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    
    if ([item isKindOfClass:[RCAddress class]]) {
        RCAddress *locationAddress = (RCAddress *)item;
        
        NSNumber *latitude = locationAddress.latitude;
        NSNumber *longitude = locationAddress.longitude;
        
        NSPredicate *predicate = [RCPredicateFactory predAddressLatitude:latitude longitude:longitude];
        
        info = [RCFavoritedProjectInfo MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return info;
}

- (void)postNotification:(id)obj
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kProjectFavoriteChangedNotification object:obj userInfo:nil];
}

- (BOOL)isItemFavoritedLocally:(id)item
{
    BOOL result = NO;
    RCFavoritedProjectInfo *info = [self infoFromItem:item];
    if (info) {
        if (info.uid) {
            result = YES;
        }
    }
    return result;
}

- (NSArray *)locallyFavoritedItems
{
    NSMutableArray *result = [NSMutableArray array];
    for (RCFavoritedProjectInfo *info in [self.userinfo.favoritedProjectInfos copy]) {
        if (!info) {continue; }
        
        RCProject *project = [RCProject MR_findFirstByAttribute:@"uid" withValue:info.projectUID inContext:[NSManagedObjectContext MR_defaultContext]];
        if (project) {
            [result insertObject:project atIndex:0];
        }
        
        NSNumber *latitude = info.latitude;
        NSNumber *longitude = info.longitude;
        [RCPredicateFactory predAddressLatitude:latitude longitude:longitude];
        NSPredicate *predicate = [RCPredicateFactory predAddressLatitude:latitude longitude:longitude];
        
        RCAddress *locationAddress = [RCAddress MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
        
        if (locationAddress) {
            [result insertObject:locationAddress atIndex:0];
        }
    }
    return result;
}

@end
