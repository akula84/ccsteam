//
//  RCTapDetector.m
//  Recity
//
//  Created by Matveev on 16/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTapDetector.h"

@interface RCTapDetector () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *targetView;
@property (strong, nonatomic) UITapGestureRecognizer *recognizer;

@end

@implementation RCTapDetector

- (void)attachToTargetView:(UIView *)targetView {
    self.targetView = targetView;
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    self.recognizer.numberOfTouchesRequired = 1;
    [targetView addGestureRecognizer:self.recognizer];
}

- (void)handleSingleTap {
    RUN_BLOCK(self.didTappedBlock);
}

@end
