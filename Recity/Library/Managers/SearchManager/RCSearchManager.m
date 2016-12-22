//
//  SearchManager.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchManager.h"
#import "RCSearchManager_Private.h"

@implementation RCSearchManager
SINGLETON_OBJECT

- (void)prepareSearchText:(NSString *)text centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
{
    self.searchText = text;
    self.centerCoordinate = centerCoordinate;
}

+ (id)resultItem
{
    return [self controller].resultItem;
}

- (void)saveContext
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
}

+ (void)resultClear
{
    [self controller].resultItem = nil;
}

+ (RCSearchManager *)controller
{
    return [RCSearchManager  shared];
}

@end
