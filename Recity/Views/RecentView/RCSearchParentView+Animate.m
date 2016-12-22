//
//  RecentView+Animate.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchParentView.h"
#import "RCSearchParentView_Private.h"

#import "CGRect+Utils.h"
#import "RCKeyBoardManager.h"

@implementation RCSearchParentView (Animate)

- (void)show
{
    self.isFirstRun = NO;
    if (self.hidden) {
        self.hidden = NO;
        self.isFirstRun = YES;
    }
    [self loadItems];
}

- (void)remove
{
    if (!self.hidden) {
        self.hidden = YES;
    }
}

- (void)startLoadAnimated
{
    if (!self.isFirstRun) {return;}
    UITableView *tableView = self.tableView;
    CGRect rectStart = CGRectSetHeight(self.frame, 50);
    tableView.frame = rectStart;
}

- (void)loadFrameWithKeyBoard
{
    CGRect rect = [RCKeyBoardManager shared].currentKeyBoardRect;
    rect = [self convertRect:rect fromView:nil];
    CGRect rectFinish = CGRectSetHeight(self.frame,CGRectGetMinY(rect));
    [UIView animateWithDuration:0.15f animations:^{
        self.tableView.frame = rectFinish;
    }];
}

@end
