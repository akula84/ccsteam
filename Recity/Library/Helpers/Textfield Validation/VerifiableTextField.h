//
//  VerifiableTextField.h
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 RC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChangeableTextField.h"
#import "TextValidationStrategy.h"

typedef void(^DidChangedTextValidationFinishedBlock)(ChangeableTextField *textField, NSError *error);//     if error == nil then is valid

@interface VerifiableTextField : ChangeableTextField

@property (strong, nonatomic) TextValidationStrategy *validationStrategy;
@property (assign, nonatomic) BOOL validateOnFly;
@property (strong, nonatomic) DidChangedTextValidationFinishedBlock didChangedTextValidationFinishedBlock;//        called when validateOnFly == YES

- (void)validateAndRunDidChangedTextValidationFinishedBlock;
- (BOOL)currentTextIsValid;

@end
