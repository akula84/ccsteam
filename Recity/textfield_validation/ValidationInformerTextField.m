//
//  InformerableTextField.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "ValidationInformerTextField.h"

@implementation ValidationInformerTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepareAllAgain];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareAllAgain];
    }
    return self;
}

- (void)prepareAllAgain {
    @weakify(self);
    self.didChangedTextValidationFinishedBlock = ^(ChangeableTextField *textField, NSError *error) {
        @strongify(self);
        if (error && error.code && self.informationLabel) {
            self.separatorView.backgroundColor = RGB(230,142,137);

            self.informationLabel.text = error.localizedDescription;
            self.informationLabel.textColor = RGB(230,142,137);
            self.informationLabel.hidden = NO;
        } else {
            [self turnIntoValidState];
        }
    };
}

- (void)turnIntoValidState {
    self.informationLabel.hidden = YES;
    self.separatorView.backgroundColor = RGB(237,237,237);
}

@end
