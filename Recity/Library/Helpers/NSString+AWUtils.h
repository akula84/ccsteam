//
//  NSString+AWUtils.h
//  
//
//  Created by Alexander Kozin on 10.07.15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (AWUtils)

- (NSString *)classNameFromBackendKey;
- (NSString *)propertyFromBackendKey;

- (NSString *)backendKeyFromPropertyName;

@end
