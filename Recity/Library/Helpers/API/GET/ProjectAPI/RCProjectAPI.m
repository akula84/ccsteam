//
//  RCProjectAPI.m
//  Recity
//
//  Created by Artem Kulagin on 08.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectAPI.h"

#import "RCProject.h"
#import "API_Protected.h"
#import "RCParseHelper.h"
#import "RCImage.h"
#import "RCShape.h"
#import "RCTenant.h"
#import "RCProjectAPIDeletedIdsAPI.h"
#import "ApiUtils.h"

@implementation RCProjectAPI

- (NSString *)path
{
    return kAPIGetProjects;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_context];
    [backgroundContext performBlock:^{
        [reply enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            [self parseObject:item aClass:[RCProject class] inContext:backgroundContext];
        }];
        [backgroundContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [self loadDeleteApi:^{
                [super apiDidReturnReply:nil source:nil];
             }];
        }];
    }];
}

- (void)apiDidFailWithError:(NSError*)error
{
    [self loadDeleteApi:^{
        [super apiDidFailWithError:error];
    }];
}

- (void)loadDeleteApi:(void(^)())complete
{
    [RCProjectAPIDeletedIdsAPI withCompletion:^(id replyIds, NSError *err, BOOL *handleError) {
        [ApiUtils saveModifiedSince];
        RUN_BLOCK(complete);
    }];
}

- (void)prepareURLRequest:(NSMutableURLRequest *)request
{
    request = [ApiUtils prepareURLRequest:request];
    [super prepareURLRequest:request];
    
}

- (id)parseObject:(id)data aClass:(Class)aClass inContext:(NSManagedObjectContext *)context
{
    RCProject *obj = [RCParseHelper createObjIsNeed:data aClass:aClass inContext:context];
    obj.images = nil;
    obj.tenants = nil;
    obj.shapes = nil;
    [obj MR_importValuesForKeysWithObject:data];
    return obj;
}


@end
