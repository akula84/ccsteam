//
//  SimpleTextField.m
//  golf-fitness
//
//  Created by Matveev on 10.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "ChangeableTextField.h"

@implementation ChangeableTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextDidChange:(NSNotification *)sender {
    if ([sender.object isEqual:self]) {
        RUN_BLOCK(self.didTextChangedBlock, self);
    }
}

- (void)setStartText:(NSString *)startText {
    _startText = startText;
    if (!startText) {
        _startText = @"";//     for right detection that textWasChanged if initially it was set as nil
    }
}

- (BOOL)initialTextWasChanged {
    BOOL result = ![self.text isEqualToString:_startText];
    return result;
}

- (void)dealloc {
//    NSLog(@"dealloc %@", [self className]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
