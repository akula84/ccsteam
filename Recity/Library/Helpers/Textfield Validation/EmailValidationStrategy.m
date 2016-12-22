//
//  EmailValidationStrategy.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "EmailValidationStrategy.h"

@interface EmailValidationStrategy ()

@property (strong, nonatomic) NSRegularExpression *regexp;

@end

@implementation EmailValidationStrategy

- (NSError *)validateText:(NSString *)text {
    NSError *resultError = [super validateText:text];
    if (!resultError) {
        NSError *error = nil;
        NSString *expression = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:text options:(NSMatchingOptions)0 range:NSMakeRange(0, [text length])];
        if (!match) {
            resultError = CUSTOM_ERROR(@"PLEASE ENTER AN EMAIL ADDRESS");
        }
    }
    return resultError;
}

@end
