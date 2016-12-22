//
//  RCProjectAPIDeletedIdsAPI.m
//  Recity
//
//  Created by Artem Kulagin on 29.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectAPIDeletedIdsAPI.h"

#import "API_Protected.h"
#import "RCProjectAPI.h"
#import "ApiUtils.h"
#import "RCUserDefaults.h"
#import "RCProject.h"

@implementation RCProjectAPIDeletedIdsAPI

- (NSString *)path
{
    return kAPIGetProjectsDeletedids;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_context];
    [backgroundContext performBlock:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@",kUid,reply];
        [RCProject MR_deleteAllMatchingPredicate:predicate inContext:backgroundContext];
        [backgroundContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [super apiDidReturnReply:nil source:nil];
        }];
    }];
}

- (void)apiDidFailWithError:(NSError*)error
{
    [super apiDidFailWithError:error];
}

- (void)prepareURLRequest:(NSMutableURLRequest *)request
{
    request = [ApiUtils prepareURLRequest:request];
    [super prepareURLRequest:request];
}

@end


