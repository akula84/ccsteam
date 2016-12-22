//
//  PopupView.m
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "PopupView.h"

@interface PopupView ()

@property (weak, nonatomic) IBOutlet UIView *popupContentView;
@property (assign) CGRect startFrame;

@end

@implementation PopupView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _startFrame = self.frame;
    }
    return self;
}

- (void)displayOnView:(UIView *)fundamentView {
    self.frame = fundamentView.bounds;
    [fundamentView addSubview:self];
    
    self.popupContentView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    self.backgroundColor = RGBA(0, 0, 0, 0.4);
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.1 delay:0.05
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0;
                     } completion:nil];
    [UIView animateWithDuration:0.25 delay:0.05
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.popupContentView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:nil];
}

- (void)hideAnimated {
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.popupContentView.transform = CGAffineTransformMakeScale(0.05, 0.05);
                     } completion:nil];
    [UIView animateWithDuration:0.1 delay:0.15
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
