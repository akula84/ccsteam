//
//  AppState.m
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "AppState.h"
#import "SSKeychain.h"
#import "KeychainManager.h"

#define kWasLaunched      @"kWasLaunched"

#define kKeychainSavedUserPasswordServiceUID                 @"recity.saved_user_password"

@interface AppState ()

@property (assign, nonatomic) BOOL isFirstLaunch;
@property (copy, nonatomic) NSString *userLogin;//        as user's uid

@end

@implementation AppState

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance prepareAll];
    });
    return sharedInstance;
}

- (void)prepareAll {
    self.isFirstLaunch = ![self wasLaunched];
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kWasLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)wasLaunched {
    BOOL result = NO;
    NSNumber *wasLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kWasLaunched];
    if (wasLaunched) {
        result = YES;
    }
    return result;
}

- (BOOL)isFirstLaunch {
    return _isFirstLaunch;
}

- (void)saveUserPasswordToKeychain:(NSString *)userPassword {
    NSLog(@"saved password %@",userPassword);
    [SSKeychain setPassword:userPassword forService:kKeychainSavedUserPasswordServiceUID account:[KeychainManager keychainAccountUID]];
}

- (NSString *)savedUserPassword {
    NSString *result = [SSKeychain passwordForService:kKeychainSavedUserPasswordServiceUID account:[KeychainManager keychainAccountUID]];
    return result;
}

- (void)eraseKeychainedUserPassword {
    [KeychainManager deleteObjectForKeychainServiceUID:kKeychainSavedUserPasswordServiceUID];
}

//- (void)setUser:(RCUser *)user {
//    self.userLogin = user.login;
//}

//- (RCUser *)user {
//    RCUser *result = [[RCUser rc_objectsWithValues:@[self.userLogin] ofFieldName:@"login" inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
//    return result;
//}

@end
