//
//  RCSearchManager+Result.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchManager.h"
#import "RCSearchManager_Private.h"

#import "RCAddress.h"
#import "RCProject.h"
#import "RCPredicateFactory.h"
#import "RCSearchAPI.h"
#import "API_Protected.h"

@implementation RCSearchManager (Result)

- (void)result:(complete)complete
{
    CLLocationCoordinate2D centerCoordinate = self.centerCoordinate;
    NSString *proximity = [NSString stringWithFormat:@"%@,%@",@(centerCoordinate.latitude),@(centerCoordinate.longitude)];
    NSDictionary *parameters =@{@"query":self.searchText,
                                @"proximity":proximity};
    [self.api.sessionTask cancel];
    self.api =  [RCSearchAPI withObject:parameters completion:^(id reply, NSError *error, BOOL *handleError) {
        if (error.code == -999) {return;}
        if (reply) {
            NSArray *array = [self parseDict:reply];
            complete(array);
        } else {
            complete(nil);
        }
    }];
}

- (NSArray *)parseDict:(NSDictionary *)object
{
    NSArray *foundLocations = [self parseFoundLocations:object];
    NSArray *project = [self parseProject:object];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:project];
    [mutableArray addObjectsFromArray:foundLocations];
    return [NSArray arrayWithArray:mutableArray];
}

- (NSArray *)parseFoundLocations:(NSDictionary *)object
{
    NSArray *arrayObject = [object objectForKey:@"foundLocations"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in arrayObject) {
        [mutableArray addObject:[RCAddress itemWithDict:dict inContext:[NSManagedObjectContext MR_defaultContext]]];
    }
    return [NSArray arrayWithArray:mutableArray];
}

- (NSArray *)parseProject:(NSDictionary *)object
{
    NSArray *allIds = [self allProjectIds:object];
    NSPredicate *predicate = [RCPredicateFactory predProjectPlannedUnderUIds:allIds];
    NSArray *projects = [RCProject MR_findAllWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    return projects;
}

- (NSArray *)allProjectIds:(NSDictionary *)object
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[object objectForKey:@"foundProjectIds"]];
    return [NSArray arrayWithArray:array];
};

@end
