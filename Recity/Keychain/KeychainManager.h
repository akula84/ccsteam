//
//  KeychainReceiptsManager.h
//  test
//
//  Created by Matveev on 22/03/16.
//  Copyright © 2016 magorasystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainManager : NSObject

+ (NSString *)keychainAccountUID;

+ (void)saveArrayToKeychain:(NSArray *)receipts keychainServiceUID:(NSString *)keychainServiceUID;
+ (NSArray *)restoreArrayFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID;

+ (void)saveDictionaryToKeychain:(NSDictionary *)dictionary keychainServiceUID:(NSString *)keychainServiceUID;
+ (NSDictionary *)restoreDictionaryFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID;

+ (void)saveNumberToKeychain:(NSNumber *)number keychainServiceUID:(NSString *)keychainServiceUID;
+ (NSNumber *)restoreNumberFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID;

+ (void)saveStringToKeychain:(NSString *)string keychainServiceUID:(NSString *)keychainServiceUID;
+ (NSString *)restoreStringFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID;

+ (void)deleteObjectForKeychainServiceUID:(NSString *)keychainServiceUID;

@end
