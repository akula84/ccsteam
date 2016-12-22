//
//  RCFloatViewSlider.m
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFloatViewSlider.h"
#import "DragDetector.h"
#import "RCMainTablesScrollView.h"
#import "RCMapToolbarView.h"

#define kFloatViewAnimationTimeInterval     0.1

@interface RCFloatViewSlider ()

@property (weak, nonatomic) IBOutlet RCMainTablesScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet RCMapToolbarView *toolbarView;

@property (strong, nonatomic) DragDetector *dragDetector;

@property (assign, nonatomic) FloatViewState lastStableFloatViewState;

@end

@implementation RCFloatViewSlider

- (void)prepareAll {
    [self addDragDetector];
}

- (void)addDragDetector {
    self.dragDetector = [[DragDetector alloc] initWithFundamentView:self.floatView];
    self.dragDetector.enabled = YES;
    
    @weakify(self);
    self.dragDetector.canHandleDragWhenTouchDownAtLocationBlock = ^(CGPoint location) {
        @strongify(self);
        
        BOOL result = NO;
        CGPoint translatedLocation = [UIView pointAtScreenCoordinates:location usedAtView:self.floatView];
        CGRect translatedFloatViewFrame = [self.floatView viewFrameAtScreenCoordinates];
        CGRect translatedFloatViewHeaderViewFrame = translatedFloatViewFrame;
        translatedFloatViewHeaderViewFrame.size.height = 50;
//        NSLog(@"location %@ translated %@",NSStringFromCGPoint(location),NSStringFromCGPoint(translatedLocation));
        if (CGRectContainsPoint(translatedFloatViewHeaderViewFrame, translatedLocation)) {
            result = YES;
            self.floatView.userInteractionEnabled = NO;
            self.floatView.userInteractionEnabled = YES;
            self.scrollView.scrollEnabled = NO;
        }
//        NSLog(@"CAN RESULT %i",result);
        return result;
    };
    self.dragDetector.willHandleDragWhenPanRecognizedAtLocationBlock = ^(CGPoint location, CGFloat lesserPositiveAngleInDegreesBetweenCurrentLocationPointAndAxisX) {
        @strongify(self);
        BOOL result = YES;
        self.floatView.height = [self maximumFreeHeight];
        //        NSLog(@"WILL RESULT %i",result);
        return result;
    };
    self.dragDetector.dragLocationChangedBlock = ^(CGPoint location, CGPoint touchDownPoint, CGPoint panRecognizedAtPoint) {
        @strongify(self);
        
        //        NSLog(@"height %@ %@ %@",@(self.view.height),@(self.scrollView.height),@(self.toolbarView.height));
        CGFloat newContentViewY = self.floatView.y + (location.y - touchDownPoint.y) - (panRecognizedAtPoint.y - touchDownPoint.y);
        if (newContentViewY < [self floatViewFullDisplayedY]) {
            self.floatView.y = [self floatViewFullDisplayedY];
        } else {
            self.floatView.y = newContentViewY;
        }
    };
    self.dragDetector.dragFinishedAtLocationBlock = ^(CGPoint location, CGPoint touchDownPoint) {
        @strongify(self);
        
//        NSLog(@"min 1 %@",@([self floatViewMinYForFullscreen]));
//        NSLog(@"min 2 %@",@([self floatViewMaxYForFullscreen]));
//        
//        NSLog(@"min 3 %@",@([self floatViewMinYForHalfscreen]));
//        NSLog(@"min 4 %@",@([self floatViewMaxYForHalfscreen]));
//        
//        NSLog(@"min 5 %@",@([self floatViewMinYForHidden]));
//        NSLog(@"min 6 %@",@([self floatViewMaxYForHidden]));
        
        CGPoint translatedFloatViewOrigin = [self.floatView viewOriginAtScreenCoordinates];
//        NSLog(@"translatedFloatViewOrigin %@",NSStringFromCGPoint(translatedFloatViewOrigin));
        
        CGPoint translatedFloatViewMinYForFullscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMinYForFullscreen]) usedAtView:self.floatView.superview];
        CGPoint translatedFloatViewMaxYForFullscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMaxYForFullscreen]) usedAtView:self.floatView.superview];
        
        CGPoint translatedFloatViewMinYForHalfscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMinYForHalfscreen]) usedAtView:self.floatView.superview];
        CGPoint translatedFloatViewMaxYForHalfscreen = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMaxYForHalfscreen]) usedAtView:self.floatView.superview];
        
        CGPoint translatedFloatViewMinYForHidden = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMinYForHidden]) usedAtView:self.floatView.superview];
        CGPoint translatedFloatViewMaxYForHidden = [UIView pointAtScreenCoordinates:CGPointMake(0,[self floatViewMaxYForHidden]) usedAtView:self.floatView.superview];
        
        FloatViewState stateWhereToTurn;
        if (translatedFloatViewMinYForFullscreen.y <= translatedFloatViewOrigin.y && translatedFloatViewOrigin.y < translatedFloatViewMaxYForFullscreen.y) {
            if ([self nowWorkingWithMenu]) {
                stateWhereToTurn = FloatViewStateMenuFullscreen;
            } else {
                stateWhereToTurn = FloatViewStateDetailsFullscreen;
            }
            [self displayFloatViewInState:stateWhereToTurn animated:YES completion:nil];
        } else if (translatedFloatViewMinYForHalfscreen.y <= translatedFloatViewOrigin.y && translatedFloatViewOrigin.y < translatedFloatViewMaxYForHalfscreen.y) {
            if ([self nowWorkingWithMenu]) {
                stateWhereToTurn = FloatViewStateMenuHalfscreen;
            } else {
                stateWhereToTurn = FloatViewStateDetailsHalfscreen;
            }
            [self displayFloatViewInState:stateWhereToTurn animated:YES completion:nil];
        } else if (translatedFloatViewMinYForHidden.y <= translatedFloatViewOrigin.y && translatedFloatViewOrigin.y < translatedFloatViewMaxYForHidden.y) {
            [self hideFloatViewAnimatedCompletion:nil];
        }
    };
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
        [self displayFloatViewInState:state animated:YES completion:^{
            @strongify(self);
            self.scrollView.scrollEnabled = YES;
            RUN_BLOCK(completion);
        }];
    } else {
        [self displayFloatViewInState:state animated:NO completion:nil];
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

- (void)displayProjectDetailsInState:(FloatViewState)state animated:(BOOL)animated completion:(dispatch_block_t)completion {
    self.scrollView.hidden = YES;
    self.projectDetailsView.hidden = NO;
    
    if (animated) {
        [self displayFloatViewInState:state animated:YES completion:^{
            [self.toolbarView switchStateToProjectDetails];
            RUN_BLOCK(completion);
        }];
    } else {
        [self displayFloatViewInState:state animated:NO completion:nil];
        [self.toolbarView switchStateToProjectDetails];
        RUN_BLOCK(completion);
    }
}

- (void)hideProjectDetailsViewAnimatedCompletion:(dispatch_block_t)completion {
    @weakify(self);
    [self hideFloatViewAnimatedCompletion:^{
        @strongify(self);
        self.projectDetailsView.hidden = YES;
        [self.toolbarView switchStateToNormal];
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
            [self displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES completion:completion2];
        }];
    } else {
        RUN_BLOCK(completion1);
        [self displayProjectDetailsInState:FloatViewStateDetailsHalfscreen animated:YES completion:completion2];
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

- (void)displayFloatViewInState:(FloatViewState)state animated:(BOOL)animated completion:(dispatch_block_t)completion {
    if (animated) {
        [UIView animateWithDuration:kFloatViewAnimationTimeInterval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self switchToState:state animated:NO completion:nil];
        } completion:^(BOOL finished) {
            self.scrollView.scrollEnabled = YES;
            RUN_BLOCK(completion);
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
        [self.toolbarView switchStateToNormal];
        [self.toolbarView resetSelectionAnimated:YES];
        RUN_BLOCK(self.didFloatViewBecameHiddenBlock);
        RUN_BLOCK(completion);
    }];
}

- (void)switchToState:(NSInteger)state animated:(BOOL)animated completion:(dispatch_block_t)completion {
    switch (state) {
        case FloatViewStateMenuFullscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewFullDisplayedY] height:[self maximumFreeHeight]];
        }break;
            
        case FloatViewStateDetailsFullscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewFullDisplayedY] height:[self maximumFreeHeight]];
            self.projectDetailsTableView.scrollEnabled = YES;
        }break;
            
        case FloatViewStateMenuHalfscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewMenuHalfDisplayedY] height:self.menuHalfDisplayedFloatViewHeight];
        }break;
            
        case FloatViewStateDetailsHalfscreen: {
            [self changeFloatViewFrameAndScrollViewContentSizeDependentOnY:[self floatViewDetailsHalfDisplayedY] height:self.detailsHalfDisplayedFloatViewHeight];
            self.projectDetailsTableView.scrollEnabled = NO;
            [self.projectDetailsTableView setContentOffset:CGPointZero animated:YES];
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
    
    self.lastStableFloatViewState = state;
}

- (NSInteger)displayedState {
    FloatViewState result;
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

- (BOOL)isScrollViewDisplayed {
    BOOL result = (([self displayedState] == FloatViewStateMenuFullscreen) || ([self displayedState] == FloatViewStateMenuHalfscreen)) && self.scrollView.hidden == NO;
    return result;
}

- (BOOL)projectDetailsViewDisplayed {
    BOOL result = (([self displayedState] == FloatViewStateDetailsFullscreen) || ([self displayedState] == FloatViewStateDetailsHalfscreen)) && self.projectDetailsView.hidden == NO;
    return result;
}

#pragma mark - Private

- (void)changeFloatViewFrameAndScrollViewContentSizeDependentOnY:(CGFloat)y height:(CGFloat)height {
    self.floatView.y = y;
    self.floatView.height = height;
    self.floatViewHeightConstraint.constant = height;
    self.floatViewBottomLayout.constant = self.toolbarView.height;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, height);
}

- (CGFloat)maximumFreeHeight {
    CGFloat result = self.mapView.height;
    return result;
}

- (CGFloat)floatViewFullDisplayedY {
    CGFloat result = self.mapView.y;
    return result;
}

- (CGFloat)floatViewMenuHalfDisplayedY {
    CGFloat result = self.toolbarView.y - self.menuHalfDisplayedFloatViewHeight;// [self maximumFreeHeight] / 2.0;
    return result;
}

- (CGFloat)floatViewDetailsHalfDisplayedY {
    CGFloat result = self.toolbarView.y - self.detailsHalfDisplayedFloatViewHeight;// [self maximumFreeHeight] / 2.0;
    return result;
}

- (CGFloat)floatViewMinYForFullscreen {
    CGFloat result = [self floatViewFullDisplayedY];
    return result;
}

- (CGFloat)floatViewMaxYForFullscreen {
    CGFloat result = [self floatViewFullDisplayedY] + [self maximumFreeHeightThird];
    return result;
}

- (CGFloat)floatViewMinYForHalfscreen {
    CGFloat result = [self floatViewMaxYForFullscreen];
    return result;
}

- (CGFloat)floatViewMaxYForHalfscreen {
    CGFloat result = [self floatViewMinYForHalfscreen] + [self maximumFreeHeightThird];
    return result;
}

- (CGFloat)floatViewMinYForHidden {
    CGFloat result = [self floatViewMaxYForHalfscreen];
    return result;
}

- (CGFloat)floatViewMaxYForHidden {
    CGFloat result = [self floatViewHiddenY];
    return result;
}

- (CGFloat)floatViewHiddenY {
    return self.mapView.bottom;
}

- (CGFloat)maximumFreeHeightThird {
    CGFloat result = [self maximumFreeHeight] / 3.0;
    return result;
}

@end
