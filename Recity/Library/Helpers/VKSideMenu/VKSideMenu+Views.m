//
//  VKSideMenu+Views.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "VKSideMenu_Private.h"

#import "UIViewController+Utils.h"
#import <PureLayout/PureLayout.h>
#import "RCMenuTableView.h"
#import "CGRect+Utils.h"

static CGFloat heightNav = 76.f;

@implementation VKSideMenu (Views)

- (void)prepareViews
{
    [self addNavBar];
    [self addTableView];
    [self addImageView];
}

- (void)addNavBar
{
    CGRect frame = self.view.bounds;
    frame = CGRectSetHeight(frame, heightNav);
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)action
{
    [self hide:nil];
}

- (void)addTableView
{
    CGRect frame = self.view.bounds;
    frame = CGRectSetY(frame, heightNav);
    frame = CGRectSetHeight(frame, CGRectGetHeight(frame) - heightNav);
    RCMenuTableView *tableView = [[RCMenuTableView alloc]initWithFrame:frame];
    [self.view addSubview:tableView];
    [tableView prepareItems:self.items];
    tableView.didSelect = ^(NSIndexPath *indexPath){
        [self didSelect:indexPath];
        
    };
}

- (void)didSelect:(NSIndexPath *)indexPath
{
    [self hide:^{
        PERFORM_BLOCK_IF_NOT_NIL(self.didSelect, indexPath);
    }];
}

- (void)addImageView
{
    UIImage *image = [UIImage imageNamed:@"menu"];
    CGSize size = image.size;
    CGFloat originX = CGRectGetWidth(self.view.bounds) - 16.f - size.width;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, 39.f, size.width, size.height)];
    [imageView setImage:image];
    [self.view addSubview:imageView ];
}

@end
