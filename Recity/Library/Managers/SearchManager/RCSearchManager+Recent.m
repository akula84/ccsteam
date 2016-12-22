//
//  SearchManager+Recent.m
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchManager.h"
#import "RCSearchManager_Private.h"

#import "RCRecentSearch.h"
#import "RCPredicateFactory.h"

@implementation RCSearchManager (Recent)

- (void)recents:(complete)complete
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_defaultContext];
    [backgroundContext performBlock:^{
        NSFetchRequest *fetchRequest = [RCRecentSearch MR_requestAll];
        fetchRequest.fetchLimit = 10;
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        NSArray *array = [RCRecentSearch MR_executeFetchRequest:fetchRequest];
        complete([self copyArray:array]);
   }];
}

- (void)addRecent:(NSString *)text
{
    RCRecentSearch *recentOld = [self recentSearchWith:text];
    if (recentOld) {
        recentOld.date = [NSDate date];
        [self saveContext];
    } else {
        [self createRecentNew:text];
    }
}

- (void)createRecentNew:(NSString *)text
{
    RCRecentSearch *recentSearch = [RCRecentSearch MR_createEntity];
    recentSearch.text = text;
    recentSearch.date = [NSDate date];
    [self saveContext];
}

- (RCRecentSearch *)recentSearchWith:(NSString *)text
{
    NSPredicate *predicate = [RCPredicateFactory predIsEgual:@"text" value:text];
    return [RCRecentSearch MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (NSArray *)copyArray:(NSArray *)originalArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSManagedObject *entity in originalArray) {
        NSManagedObject *resultEntity = [[NSManagedObjectContext MR_defaultContext] objectWithID: entity.objectID];
        [array addObject:resultEntity];
    }
    return array;
}

@end
