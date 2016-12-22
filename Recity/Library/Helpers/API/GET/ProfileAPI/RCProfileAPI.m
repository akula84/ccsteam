//
//  RCProfileAPI.m
//  Recity
//
//  Created by Artem Kulagin on 28.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProfileAPI.h"

#import "API_Protected.h"
#import "AppState.h"
#import "RCUser.h"
#import "RCFilterManager.h"

@implementation RCProfileAPI

- (NSString *)path
{
    return kAPIProfile;
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    [self prepareUser:reply];
    [[RCFilterManager shared] setupDefaults];
    [super apiDidReturnReply:reply source:source];
}

- (void)prepareUser:(id)reply
{
    RCUser *user = [AppState sharedInstance].user;
    [user MR_importValuesForKeysWithObject:reply];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:nil];
}

@end
