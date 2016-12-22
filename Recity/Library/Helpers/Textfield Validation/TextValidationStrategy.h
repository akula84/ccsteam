//
//  ValidationStrategy.h
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 RC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextValidationStrategy : NSObject

@property (strong, nonatomic) NSNumber *minLength;
@property (strong, nonatomic) NSNumber *maxLength;

- (instancetype)initWithMinLength:(NSNumber *)minLength maxLength:(NSNumber *)maxLength;
- (NSError *)validateText:(NSString *)text;

@end
