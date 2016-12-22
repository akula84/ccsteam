//
//  RCSearchResultView+LoadingView.m
//  Recity
//
//  Created by Artem Kulagin on 03.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchResultView_Private.h"

#import "LoaderView.h"
#import "RCKeyBoardManager.h"
#import "CGRect+Utils.h"

@implementation RCSearchResultView (LoadingView)

- (void)addLoadingView
{
    LoaderView *loaderView = [[LoaderView alloc]initWithFrame:[self currentFrameLoaderView]];
    [self addSubview: loaderView];
    self.loaderView = (LoaderView *)loaderView;
}

- (void)loadinViewHidden:(BOOL)hidden
{
    [self loadingViewActualFrame];
    self.loaderView.hidden = hidden;
}

- (void)loadingViewActualFrame
{
    [UIView animateWithDuration:kKeyBoardAnimation animations:^{
        self.loaderView.frame = [self currentFrameLoaderView];
    }];
}

- (CGRect)currentFrameLoaderView
{
    CGRect rect = [RCKeyBoardManager shared].currentKeyBoardRect;
    rect = [self convertRect:rect fromView:nil];
    
    CGFloat heightCell = [RCSearchCell height];
    CGRect bounds = self.bounds;
    bounds.origin.y = heightCell;
    return CGRectSetHeight(bounds, CGRectGetMinY(rect) - heightCell);
}

- (void)loadFrameWithKeyBoard
{
    [super loadFrameWithKeyBoard];
    [self loadingViewActualFrame];
}

@end
