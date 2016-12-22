//
//  RCBaseViewSlider.h
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCBaseViewSlider : NSObject


@property (weak, nonatomic) IBOutlet UIView *fundamentView;
@property (weak, nonatomic) IBOutlet UIView *floatView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatViewBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatViewHeightConstraint;

- (instancetype)initWithFloatView:(UIView *)view fundamentView:(UIView *)fundamentView floatViewBottomLayout:(NSLayoutConstraint *)floatViewBottomLayout floatViewHeightConstraint:(NSLayoutConstraint *)floatViewHeightConstraint;

//      MUST BE IMPLEMENTED
- (void)switchToState:(NSInteger)state animated:(BOOL)animated completion:(dispatch_block_t)completion;
- (NSInteger)displayedState;

@end
