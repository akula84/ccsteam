//
//  VerifiableTextField.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 RC. All rights reserved.
//

#import "VerifiableTextField.h"

@implementation VerifiableTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareAll];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareAll];
    }
    return self;
}

- (void)prepareAll {
    @weakify(self);
    self.didTextChangedBlock = ^(ChangeableTextField *textField) {
        @strongify(self);
        if (self.validateOnFly) {
            [self validateAndRunDidChangedTextValidationFinishedBlock];
        }
    };
}

- (NSError *)validateText:(NSString *)text {
    NSError *resultError = nil;
    if (self.validationStrategy) {
        resultError = [self.validationStrategy validateText:self.text];
    }
    return resultError;
}

- (void)validateAndRunDidChangedTextValidationFinishedBlock {
    NSError *error = [self validateText:self.text];
    RUN_BLOCK(self.didChangedTextValidationFinishedBlock, self, error);
}

- (BOOL)currentTextIsValid {
    BOOL result = NO;
    NSError *error = [self.validationStrategy validateText:self.text];
    result = (error == nil && error.code == 0);
    return result;
}

@end
