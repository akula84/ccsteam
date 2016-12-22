//
//  RCFloatViewSlider.m
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewSlider.h"
#import "RCFloatViewSlider_Private.h"

#import "RCMainTablesScrollView.h"
#import "RCAddressPageController.h"
#import "RCDetailsPageController.h"
#import "DragDetector.h"

#define kFloatViewAnimationTimeInterval     0.1

@interface RCFloatViewSlider ()

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet RCMapToolbarView *toolbarView;

@end

@implementation RCFloatViewSlider

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self prepareController];
}

- (BOOL)canOpenFullscreen
{
    BOOL result = YES;
    
    UIViewController *controller = [self.detailPager.viewControllers firstObject];
    if (controller && [controller respondsToSelector:@selector(canFullScreen)]) {
        result = (BOOL)[controller performSelector:@selector(canFullScreen)];
    }
    
    return result;
}

- (BOOL)canOpenHalfscreen
{
    BOOL result = YES;
    
    UIViewController *controller = [self.detailPager.viewControllers firstObject];
    if (controller && [controller respondsToSelector:@selector(canHalfScreen)]) {
        result = (BOOL)[controller performSelector:@selector(canHalfScreen)];
    }
    
    return result;
}

- (void)prepareAll {
    [self addDragDetector];
}

- (void)setProjectDetailsTableView:(UITableView *)projectDetailsTableView
{
    _projectDetailsTableView = projectDetailsTableView;
    /*
    if (self.pagerPanRecognizer) {
        UIGestureRecognizer *tableScrollRecognizer = [projectDetailsTableView gestureRecognizers][0];
        [self.pagerPanRecognizer requireGestureRecognizerToFail:tableScrollRecognizer];
    }
     */
}

- (BOOL)nowWorkingWithMenu {
    BOOL result = self.lastStableFloatViewState == FloatViewStateMenuHalfscreen || self.lastStableFloatViewState == FloatViewStateMenuFullscreen;
    return result;
}

#pragma mark - Switching

- (void)displayMenuInState:(FloatViewState)state animated:(BOOL)animated completion:(dispatch_block_t)completion {
    self.projectDetailsView.hidden = YES;
    self.scrollView.hidden = NO;
    if (animated) {
        @weakify(self);
        [self displayFloatViewInState:state animated:YES timeInterval:nil completion:^{
            @strongify(self);
            self.scrollView.scrollEnabled = YES;
            RUN_BLOCK(completion);
        }];
    } else {
        [self displayFloatViewInState:state animated:NO timeInterval:nil completion:nil];
        RUN_BLOCK(completion);
    }
}

- (void)hideMenuAnimatedCompletion:(dispatch_block_t)completion {
    @weakify(self);
    [self hideFloatViewAnimatedCompletion:^{
        @strongify(self);
        [self.toolbarView resetSelectionAnimated:NO];
        self.scrollView.scrollEnabled = YES;
        self.scrollView.hidden = YES;
        RUN_BLOCK(completion);
    }];
}

- (void)displayProjectDetailsInState:(FloatViewState)state animated:(BOOL)animated timeInterval:(NSNumber *)timeInterval completion:(dispatch_block_t)completion {
    self.scrollView.hidden = YES;
    self.projectDetailsView.hidden = NO;
    
   // self.pagerPanRecognizer.enabled = (state == FloatViewStateDetailsHalfscreen);
    
    if (animated) {
        [self displayFloatViewInState:state animated:YES timeInterval:timeInterval completion:^{
            RUN_BLOCK(completion);
        }];
    } else {
        [self displayFloatViewInState:state animated:NO timeInterval:nil completion:nil];
        RUN_BLOCK(completion);
    }
}

- (void)hideProjectDetailsViewAnimatedCompletion:(dispatch_block_t)completion {
    @weakify(self);
    [self hideFloatViewAnimatedCompletion:^{
        @strongify(self);
        self.projectDetailsView.hidden = YES;
        [RCToolbarController switchToolbarToState:RCMapToolbarViewStateNormal];
        RUN_BLOCK(completion);
    }];
}

- (void)hideMenuCompletion:(dispatch_block_t)completion1 andDisplayProjectDetailsAnimatedCompletion:(dispatch_block_t)completion2 {
    BOOL scrollViewDisplayed = [self isScrollViewDisplayed];
    if (scrollViewDisplayed) {
        @weakify(self);
        [self hideMenuAnimatedCompletion:^{
            @strongify(self);
            RUN_BLOCK(completion1);
            [self displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES timeInterval:nil completion:completion2];
        }];
    } else {
        //RUN_BLOCK(completion1);
        [self displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES timeInterval:nil completion:completion2];
    }
}

- (void)hideProjectDetailsViewDisplayScrollViewAnimated {
    BOOL projectDetailsViewDisplayed = [self projectDetailsViewDisplayed];
    if (projectDetailsViewDisplayed) {
        @weakify(self);
        [self hideProjectDetailsViewAnimatedCompletion:^{
            @strongify(self);
            [self displayMenuInState:FloatViewStateMenuHalfscreen animated:YES completion:nil];
        }];
    } else {
        [self displayMenuInState:FloatViewStateMenuHalfscreen animated:YES completion:nil];
    }
}

- (void)displayFloatViewInState:(FloatViewState)state animated:(BOOL)animated timeInterval:(NSNumber *)timeInterval completion:(dispatch_block_t)completion {
    if (animated) {
        NSTimeInterval duration = kFloatViewAnimationTimeInterval;
        if (timeInterval) {
            duration = [timeInterval doubleValue];
        }
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self switchToState:state animated:NO completion:nil];
        } completion:^(BOOL finished) {
            self.scrollView.scrollEnabled = YES;
            RUN_BLOCK(completion);
            if(finished) {
                self.isScrollViewMoved = NO;
            }
        }];
    } else {
        [self switchToState:state animated:NO completion:nil];
        RUN_BLOCK(completion);
    }
}

- (void)hideFloatViewAnimatedCompletion:(dispatch_block_t)completion {
    [UIView animateWithDuration:kFloatViewAnimationTimeInterval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self switchToState:FloatViewStateHidden animated:NO completion:nil];
    } completion:^(BOOL finished) {
        [self.toolbarView resetSelectionAnimated:NO];
        self.scrollView.scrollEnabled = YES;
        [RCToolbarController switchToolbarToState:RCMapToolbarViewStateNormal];
        [self.toolbarView resetSelectionAnimated:YES];
        RUN_BLOCK(self.didFloatViewBecameHiddenBlock);
        RUN_BLOCK(completion);
        if(finished) {
            self.isScrollViewMoved = NO;
        }
    }];
}

- (void)switchToState:(NSInteger)state animated:(BOOL)animated completion:(dispatch_block_t)completion
{
    UITableView *table = self.projectDetailsTableView;
    switch (state) {
        case FloatViewStateMenuFullscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewFullDisplayedY] height:[self maximumFreeHeight]];
        }break;
            
        case FloatViewStateDetailsFullscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewFullDisplayedY] height:[self maximumFreeHeight]];
            table.scrollEnabled = YES;
        }break;
            
        case FloatViewStateMenuHalfscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewMenuHalfDisplayedY] height:self.menuHalfDisplayedFloatViewHeight];
        }break;
            
        case FloatViewStateDetailsHalfscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewDetailsHalfDisplayedY] height:self.detailsHalfDisplayedFloatViewHeight];
            RUN_BLOCK(self.didFloatViewBecameHalfBlock);
            table.scrollEnabled = NO;
            [table setContentOffset:CGPointZero animated:YES];
        }break;
            
        case FloatViewStateHidden: {
            self.floatView.y = [self floatViewHiddenY];
            self.floatViewBottomLayout.constant = -self.floatView.height;
            if ([self nowWorkingWithMenu]) {
                self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.menuHalfDisplayedFloatViewHeight);
            } else {
                self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.detailsHalfDisplayedFloatViewHeight);
            }
        }break;
            
        default:
            break;
    }
    
    if(self.lastStableFloatViewState != state) {
        self.isScrollViewMoved = YES;
    } else {
        self.isScrollViewMoved = NO;
    }
    self.lastStableFloatViewState = state;
}

- (FloatViewState)displayedState
{
    FloatViewState result = 0;
    if ([self nowWorkingWithMenu]) {
        CGFloat fullDisplayedY = [self floatViewFullDisplayedY];
        CGFloat halfDisplayedY = [self floatViewMenuHalfDisplayedY];
        CGFloat hiddenY = [self floatViewHiddenY];
        if ([Utils floatNumber:self.floatView.y isEqualToFloatNumber:fullDisplayedY]) {
            result = FloatViewStateMenuFullscreen;
        } else if ([Utils floatNumber:self.floatView.y isEqualToFloatNumber:halfDisplayedY]) {
            result = FloatViewStateMenuHalfscreen;
        } else if ([Utils floatNumber:self.floatView.y isEqualToFloatNumber:hiddenY]) {
            result = FloatViewStateHidden;
        }
    } else {
        CGFloat fullDisplayedY = [self floatViewFullDisplayedY];
        CGFloat halfDisplayedY = [self floatViewDetailsHalfDisplayedY];
        CGFloat hiddenY = [self floatViewHiddenY];
        if ([Utils floatNumber:self.floatView.y isEqualToFloatNumber:fullDisplayedY]) {
            result = FloatViewStateDetailsFullscreen;
        } else if ([Utils floatNumber:self.floatView.y isEqualToFloatNumber:halfDisplayedY]) {
            result = FloatViewStateDetailsHalfscreen;
        } else if ([Utils floatNumber:self.floatView.y isEqualToFloatNumber:hiddenY]) {
            result = FloatViewStateHidden;
        }
    }
    return result;
}

- (BOOL)isPanRecognizedOnLastRecognizedTouch
{
    BOOL result = self.dragDetector.isPanRecognizedOnLastRecognizedTouch;
    return result;
}

- (BOOL)isScrollViewDisplayed
{
    BOOL result = (([self displayedState] == FloatViewStateMenuFullscreen) || ([self displayedState] == FloatViewStateMenuHalfscreen)) && self.scrollView.hidden == NO;
    return result;
}

- (BOOL)projectDetailsViewDisplayed
{
    BOOL result = (([self displayedState] == FloatViewStateDetailsFullscreen) || ([self displayedState] == FloatViewStateDetailsHalfscreen)) && self.projectDetailsView.hidden == NO;
    return result;
}

#pragma mark - Private

- (void)changeFloatViewFrameAndScrollViewContentSizeDependentOnY:(CGFloat)y height:(CGFloat)height
{
    self.floatView.y = y;
    self.floatView.height = height;
    self.floatViewHeightConstraint.constant = height;
    self.floatViewBottomLayout.constant = self.toolbarView.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, height);
}

- (CGFloat)maximumFreeHeight
{
    CGFloat result = self.mapView.height;
    return result;
}

- (CGFloat)floatViewFullDisplayedY
{
    CGFloat result = self.mapView.y;
    return result;
}

- (CGFloat)floatViewMenuHalfDisplayedY
{
    CGFloat result = self.toolbarView.y - self.menuHalfDisplayedFloatViewHeight;// [self maximumFreeHeight] / 2.0;
    return result;
}

- (CGFloat)floatViewDetailsHalfDisplayedY
{
    CGFloat result = self.toolbarView.y - self.detailsHalfDisplayedFloatViewHeight;// [self maximumFreeHeight] / 2.0;
    return result;
}

- (CGFloat)floatViewMinYForFullscreen
{
    CGFloat result = [self floatViewFullDisplayedY];
    return result;
}

- (CGFloat)floatViewMaxYForFullscreen
{
    CGFloat result = [self floatViewFullDisplayedY] + [self maximumFreeHeightThird];
    return result;
}

- (CGFloat)floatViewMinYForHalfscreen
{
    CGFloat result = [self floatViewMaxYForFullscreen];
    return result;
}

- (CGFloat)floatViewMaxYForHalfscreen
{
    CGFloat result = [self floatViewMinYForHalfscreen] + [self maximumFreeHeightThird];
    return result;
}

- (CGFloat)floatViewMinYForHidden
{
    CGFloat result = [self floatViewMaxYForHalfscreen];
    return result;
}

- (CGFloat)floatViewMaxYForHidden
{
    CGFloat result = [self floatViewHiddenY];
    return result;
}

- (CGFloat)floatViewHiddenY
{
    return self.mapView.bottom;
}

- (CGFloat)maximumFreeHeightThird
{
    CGFloat result = [self maximumFreeHeight] / 3.0f;
    return result;
}

@end
