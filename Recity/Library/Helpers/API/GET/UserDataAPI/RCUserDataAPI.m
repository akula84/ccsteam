//
//  RCUserDataAPI.m
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserDataAPI.h"

#import "RCUserInfo.h"
#import "RCParseHelper.h"
#import "API_Protected.h"
#import "RCAddress.h"

@implementation RCUserDataAPI

- (NSString *)path
{
    return kAPIGetUserData;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_context];
    [backgroundContext performBlock:^{
        RCUserInfo *userInfo = [RCParseHelper createObjIsNeed:reply aClass:[RCUserInfo class] inContext:backgroundContext];
        [userInfo parse:reply];
        [backgroundContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
             RCUserInfo *copyObject = [RCParseHelper copyObject:userInfo];
            [AppState sharedInstance].user.userinfo = copyObject;
             [super apiDidReturnReply:copyObject source:source];
        }];
    }];
}

@end
