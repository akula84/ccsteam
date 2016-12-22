//
//  PasswordValidationStrategy.m
//  Recity
//
//  Created by Matveev on 14/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "PasswordValidationStrategy.h"

@implementation PasswordValidationStrategy

- (NSError *)validateText:(NSString *)text {
    NSError *resultError = [super validateText:text];
    if (resultError) {
        resultError = CUSTOM_ERROR(@"PLEASE ENTER A VALID PASSWORD");
    }
    return resultError;
}

@end
