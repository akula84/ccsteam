//
//  KeychainReceiptsManager.m
//  test
//
//  Created by Matveev on 22/03/16.
//  Copyright © 2016 magorasystems. All rights reserved.
//

#import "KeychainManager.h"
#import "SSKeychain.h"
#import "NSData+Base64.h"

@implementation KeychainManager

+ (void)saveArrayToKeychain:(NSArray *)array keychainServiceUID:(NSString *)keychainServiceUID {//       we should protect our receipts !!!! Keychain is best kind of method for avoid problems with app reject by encryption problems... It is best free variant
    if (array) {
        NSData * receiptsData = [NSKeyedArchiver archivedDataWithRootObject:array];
        NSString *base64encodedReceiptsDataString = [receiptsData base64EncodedString];
        
        [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
        //      protect our array of receipts
        [SSKeychain setPassword:base64encodedReceiptsDataString forService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
    }
}

+ (NSArray *)restoreArrayFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    NSArray *result;
    NSString *base64encodedReceiptsDataString = [SSKeychain passwordForService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
    if (base64encodedReceiptsDataString) {
        NSData *receiptsData = [NSData dataFromBase64String:base64encodedReceiptsDataString];
        result = [NSKeyedUnarchiver unarchiveObjectWithData:receiptsData];
    }
    return result;
}

+ (void)saveDictionaryToKeychain:(NSDictionary *)dictionary keychainServiceUID:(NSString *)keychainServiceUID {//       we should protect our receipts !!!! Keychain is best kind of method for avoid problems with app reject by encryption problems... It is best free variant
    if (dictionary) {
        NSData * receiptsData = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        NSString *base64encodedReceiptsDataString = [receiptsData base64EncodedString];
        
        [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
        //      protect our array of receipts
        [SSKeychain setPassword:base64encodedReceiptsDataString forService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
    }
}

+ (NSDictionary *)restoreDictionaryFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    NSDictionary *result;
    NSString *base64encodedReceiptsDataString = [SSKeychain passwordForService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
    if (base64encodedReceiptsDataString) {
        NSData *receiptsData = [NSData dataFromBase64String:base64encodedReceiptsDataString];
        result = [NSKeyedUnarchiver unarchiveObjectWithData:receiptsData];
    }
    return result;
}

+ (void)saveNumberToKeychain:(NSNumber *)number keychainServiceUID:(NSString *)keychainServiceUID {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:number];
    NSString *base64encodedDataString = [data base64EncodedString];
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    //      protect our array of receipts
    [SSKeychain setPassword:base64encodedDataString forService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
}

+ (NSNumber *)restoreNumberFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    NSNumber *result;
    NSString *base64encodedDataString = [SSKeychain passwordForService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
    if (base64encodedDataString) {
        NSData *data = [NSData dataFromBase64String:base64encodedDataString];
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return result;
}

+ (void)saveStringToKeychain:(NSString *)string keychainServiceUID:(NSString *)keychainServiceUID {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:string];
    NSString *base64encodedDataString = [data base64EncodedString];
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    //      protect our array of receipts
    [SSKeychain setPassword:base64encodedDataString forService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
}

+ (NSString *)restoreStringFromKeychainWithKeychainServiceUID:(NSString *)keychainServiceUID {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
    NSString *result;
    NSString *base64encodedDataString = [SSKeychain passwordForService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
    if (base64encodedDataString) {
        NSData *data = [NSData dataFromBase64String:base64encodedDataString];
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return result;
}

+ (void)deleteObjectForKeychainServiceUID:(NSString *)keychainServiceUID {
    [SSKeychain deletePasswordForService:keychainServiceUID account:[KeychainManager keychainAccountUID]];
}

+ (NSString *)keychainAccountUID {
    NSString *result = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    [result stringByAppendingString:@".keychain"];
    return result;
}

@end
