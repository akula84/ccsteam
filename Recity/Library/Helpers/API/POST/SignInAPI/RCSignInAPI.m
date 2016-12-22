//
//  RCSignInAPI.m
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSignInAPI.h"

#import "RCUser.h"
#import <MagicalRecord/MagicalRecord.h>
#import "API_Protected.h"
#import "RCParseHelper.h"
#import "RCProfileAPI.h"

@implementation RCSignInAPI

- (NSString *)path
{
    return kAPIPostSignIn;
}

- (NSMutableDictionary *)parameters
{
    return nil;
}

- (NSString *)bodyParameters
{
    NSDictionary *object = self.object;
    return [NSString stringWithFormat:@"username=%@&password=%@&grant_type=password",
            object[kLogin], object[kPassword]];
}

- (void)apiDidReturnReply:(id)reply source:(id)source
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_context];
    [backgroundContext performBlock:^{
        RCUser *user = [RCParseHelper parseObject:reply aClass:[RCUser class] inContext:backgroundContext];
        user.authorizationToken = reply[@"access_token"];
        user.login = self.object[kLogin];
       [backgroundContext MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
           RCUser *copyUser = [RCParseHelper copyObject:user];
           [AppState sharedInstance].user = copyUser;
           [RCProfileAPI withCompletion:^(id profilereply, NSError *profileerror, BOOL *profilehandleError) {
               [AppState saveUserLogin:self.object[kLogin] passwordToKeychain:self.object[kPassword]];
               [super apiDidReturnReply:copyUser source:source];
           }];
        }];
    }];
}

@end
