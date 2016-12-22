//
//  RCFloatViewSlider.h
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseViewSlider.h"
#import "RCProjectDetailsViewController.h"

typedef NS_ENUM(NSInteger,FloatViewState) {
    FloatViewStateHidden = 0,
    FloatViewStateMenuHalfscreen = 1,
    FloatViewStateMenuFullscreen = 2,
    FloatViewStateDetailsHalfscreen = 3,
    FloatViewStateDetailsFullscreen = 4,
};

typedef void (^RCFloatViewStateBlock) (FloatViewState state);

@interface RCFloatViewSlider : RCBaseViewSlider

@property (weak, nonatomic) UIView *projectDetailsView;
@property (weak, nonatomic) UITableView *projectDetailsTableView;

@property (assign, nonatomic) CGFloat menuHalfDisplayedFloatViewHeight;
@property (assign, nonatomic) CGFloat detailsHalfDisplayedFloatViewHeight;

@property (strong, nonatomic) dispatch_block_t didFloatViewBecameHiddenBlock;
@property (strong, nonatomic) RCFloatViewStateBlock shouldTurnToStateBlock;

- (void)prepareAll;

- (void)hideMenuCompletion:(dispatch_block_t)completion1 andDisplayProjectDetailsAnimatedCompletion:(dispatch_block_t)completion2;

- (void)displayMenuInState:(FloatViewState)state animated:(BOOL)animated completion:(dispatch_block_t)completion;
- (void)displayProjectDetailsInState:(FloatViewState)state animated:(BOOL)animated completion:(dispatch_block_t)completion;

- (void)hideFloatViewAnimatedCompletion:(dispatch_block_t)completion;

- (BOOL)isScrollViewDisplayed;

- (NSInteger)displayedState;

@end
