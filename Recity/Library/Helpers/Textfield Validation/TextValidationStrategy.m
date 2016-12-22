//
//  ValidationStrategy.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 RC. All rights reserved.
//

#import "TextValidationStrategy.h"

@implementation TextValidationStrategy

- (instancetype)initWithMinLength:(NSNumber *)minLength maxLength:(NSNumber *)maxLength {
    self = [super init];
    if (self) {
        _minLength = minLength;
        _maxLength = maxLength;
    }
    return self;
}

- (NSError *)validateText:(NSString *)text {
    NSError *resultError = nil;
    if (self.minLength) {
        if (text.length < (NSUInteger)self.minLength.integerValue) {
            resultError = CUSTOM_ERROR(@"Text is too short");
        }
    } else if (self.maxLength) {
        if (text.length > (NSUInteger)self.maxLength.integerValue) {
            resultError = CUSTOM_ERROR(@"Text is too long");
        }
    }
    return resultError;
}

@end
