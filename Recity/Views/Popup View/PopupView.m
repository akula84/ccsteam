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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _startFrame = self.frame;
    }
    return self;
}

- (void)displayOnView:(UIView *)fundamentView
{
    self.frame = fundamentView.bounds;
    [fundamentView addSubview:self];
    
    self.popupContentView.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
    
    self.backgroundColor = RGBA(0, 0, 0, 0.4f);
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:0.1f delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     } completion:nil];
    [UIView animateWithDuration:0.2f delay:0.05f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.popupContentView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:nil];
}

- (void)hideAnimated {
    [UIView animateWithDuration:0.2f delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.popupContentView.transform = CGAffineTransformMakeScale(0.05f, 0.05f);
                     } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.15f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

+ (instancetype)loadNib
{
    return [[[NSBundle mainBundle] loadNibNamed:[self rc_className] owner:nil options:nil] firstObject];
}

@end
