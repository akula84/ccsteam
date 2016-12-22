//
//  SimpleTextField.h
//  golf-fitness
//
//  Created by Matveev on 10.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeableTextField;

typedef void(^DidTextChangedBlock)(ChangeableTextField *textField);

@interface ChangeableTextField : UITextField

@property (copy, nonatomic) NSString *startText;
@property (strong, nonatomic) DidTextChangedBlock didTextChangedBlock;

- (BOOL)initialTextWasChanged;//       you should set startText for using of it

@end
