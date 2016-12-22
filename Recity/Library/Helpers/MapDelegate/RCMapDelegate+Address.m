//
//  RCMapDelegate+Address.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapDelegate.h"
#import "RCMapDelegate_Private.h"

#import "RCAddress.h"
#import "RCAnnotationAddress.h"
#import "RCSearchManager.h"
#import "RCMapController.h"
#import "RCPredicateFactory.h"
#import "MyLocationButtonController.h"

@implementation RCMapDelegate (Address)

- (void)showAddress:(RCAddress *)address
{
    [MyLocationButtonController prepareActived:NO];
    if ([address isSelected] ) {
        return;
    }
    [self checkShowSearchResult:address];
    [self deSelectCurrentProject];
    [self deSelectCurrentAddress:^{
        [RCMapController shared].selectedItem = address;
        [self reloadVisibleAddress];
    }];
}

- (void)checkShowSearchResult:(RCAddress *)address
{
    self.searchManager.showResultAddressInMap = [address isSearchResult];
}

- (RCSearchManager *)searchManager
{
    return [RCSearchManager shared];
}

- (void)deSelectCurrentAddress
{
    [self deSelectCurrentAddress:nil];
}

- (void)deSelectCurrentAddress:(void(^)())complete
{
    if (![[RCMapController shared].selectedItem isKindOfClass:[RCAddress class]]) {
        RUN_BLOCK(complete);
        return;
    }
    
    [RCMapController selectedClear];
    [self reloadVisibleAddress:complete];
}

- (void)reloadVisibleAddress
{
    [self reloadVisibleAddress:nil];
}

- (void)reloadVisibleAddress:(void(^)())complete
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FBClusteringManager *clusteringManager = self.clusteringManager;
        NSArray *filtered = [self clusteringManagerAnnotationAddress];
        [clusteringManager removeAnnotations:filtered];
        NSArray *allVisibleAddress = [self allVisibleAddress];
        NSMutableArray *annotations = [NSMutableArray array];
        for (RCAddress *address in allVisibleAddress) {
            [annotations addObject:[RCAnnotationAddress itemWithAddress:address]];
        }
        [clusteringManager addAnnotations:annotations];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAnnotations:^{
                [self prepareNavTitleIfNeed];
                RUN_BLOCK(complete);
            }];
        });
    });
}

- (void)prepareNavTitleIfNeed
{
    id resultItem = [RCSearchManager resultItem];
    NSArray *addresses = [[self clusteringManagerAnnotationAddress] valueForKey:@"address"];
    if ([addresses containsObject:resultItem]) {return;}
    if (self.searchManager.searchInProgress) {return;}
    
    [RCMapController prepareDefaultTitle];
}

- (NSArray *)allVisibleAddress
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *favoritesAddress = [self favoritedAddress];
    if (favoritesAddress) {
        [result addObjectsFromArray:favoritesAddress];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    RCAddress *selectedAddress = [RCMapController selectedAddress];
    if (selectedAddress) {
        [array addObject:selectedAddress];
    }
    
    id resultItem = [RCSearchManager resultItem];
    if ([self isKindLocationAddress:resultItem]&&self.searchManager.showResultAddressInMap) {
        [array addObject:resultItem];
    }
    
    for (RCAddress *item in array) {
        NSPredicate *pred = [RCPredicateFactory predAddressLatitude:item.latitude longitude:item.longitude];
        NSArray *filter = [result filteredArrayUsingPredicate:pred];
        if (filter.isFull) {continue;}
        [result addObject:item];
    }

    return result;
}

- (BOOL)isKindAddress:(id)item
{
    return [item isKindOfClass:[RCAnnotationAddress class]];
}

- (NSArray *)favoritedAddress
{
    NSArray *items = [[AppState sharedInstance].user locallyFavoritedItems];
    NSPredicate *predicate = [RCPredicateFactory predIsKind:[RCAddress class]];
    return [items filteredArrayUsingPredicate:predicate];
}

- (BOOL)isKindLocationAddress:(id)item
{
    return [item isKindOfClass:[RCAddress class]];
}

- (NSArray *)clusteringManagerAnnotationAddress
{
    NSPredicate *predicate = [RCPredicateFactory predIsKind:[RCAnnotationAddress class]];
    return [[self.clusteringManager allAnnotations] filteredArrayUsingPredicate:predicate];
}

@end
