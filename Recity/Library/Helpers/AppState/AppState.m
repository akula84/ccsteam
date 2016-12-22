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
#import "RCCity.h"
#import "RCPredicateFactory.h"

#import "RCUser.h"

#define kWasLaunched      @"kWasLaunched"
#define kMapSettings @"kMapSettings"

#define kKeychainSavedUserLoginServiceUID                 @"recity.saved_user_login"
#define kKeychainSavedUserPasswordServiceUID                 @"recity.saved_user_password"

@interface AppState ()

@property (assign, nonatomic) BOOL isFirstLaunch;
@property (strong, nonatomic) RCCity *currentCity;

@end

@implementation AppState

- (RCCity *)currentCity
{
    if (!_currentCity) {
        NSNumber *homeCityId = self.user.homeCityId;
        _currentCity = [RCCity MR_findFirstWithPredicate:[RCPredicateFactory predUid:homeCityId]inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return _currentCity;
}

+ (BOOL)advancedVersion
{
    return [[self user] hasAdvancedSubscription];
}

+ (AppState *)controller
{
    return [AppState sharedInstance];
}

+ (RCUser *)user
{
    return [[self controller] user];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance prepareAll];
    });
    return sharedInstance;
}

- (void)prepareAll
{
    self.isFirstLaunch = ![self wasLaunched];
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:kWasLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)wasLaunched
{
    BOOL result = NO;
    NSNumber *wasLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kWasLaunched];
    if (wasLaunched) {
        result = YES;
    }
    return result;
}

- (BOOL)isFirstLaunch
{
    return _isFirstLaunch;
}

+ (void)saveUserLogin:(NSString *)userLogin passwordToKeychain:(NSString *)userPassword
{
    NSLog(@"saved login %@",userLogin);
    NSLog(@"saved password %@",userPassword);
    [SSKeychain setPassword:userLogin forService:kKeychainSavedUserLoginServiceUID account:[self keychainAccountUID]];
    [SSKeychain setPassword:userPassword forService:kKeychainSavedUserPasswordServiceUID account:[self keychainAccountUID]];
}

+ (NSString *)savedUserLogin
{
    NSString *result = [SSKeychain passwordForService:kKeychainSavedUserLoginServiceUID account:[self keychainAccountUID]];
    return result;
}

+ (NSString *)savedUserPassword
{
    NSString *result = [SSKeychain passwordForService:kKeychainSavedUserPasswordServiceUID account:[self keychainAccountUID]];
    return result;
}

+ (NSString *)keychainAccountUID
{
    return [KeychainManager keychainAccountUID];
}

+ (void)eraseKeychainedUserLoginAndPassword
{
    [KeychainManager deleteObjectForKeychainServiceUID:kKeychainSavedUserLoginServiceUID];
    [KeychainManager deleteObjectForKeychainServiceUID:kKeychainSavedUserPasswordServiceUID];
}

+ (BOOL)isHaveToken
{
    RCUser *firstUser = [RCUser MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    BOOL isHaveToken = NO;
    if (firstUser.authorizationToken.isFull) {
        [self controller].user = firstUser;
        isHaveToken = YES;
    }
    return isHaveToken;
}

+ (void)logOut:(void(^)(void))complete
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [[self user] MR_deleteEntityInContext:context];
    [context MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self eraseKeychainedUserLoginAndPassword];
        RUN_BLOCK(complete);
    }];
}

+ (void)saveMapSettings:(RCMapSettings *)mapSettings
{
    NSData *saveData = mapSettings ? [NSKeyedArchiver archivedDataWithRootObject:mapSettings] : nil;
    [[NSUserDefaults standardUserDefaults] setObject:saveData
                                              forKey:kMapSettings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (RCMapSettings *)loadMapSettings
{
    NSData *mapSettingsData = [[NSUserDefaults standardUserDefaults] objectForKey:kMapSettings];
    RCMapSettings *result = nil;
    if(mapSettingsData.length > 0) {
        result = [NSKeyedUnarchiver unarchiveObjectWithData:mapSettingsData];
    } else {
        result = [RCMapSettings defaultMapSettings];
    }
    return result;
}

@end
