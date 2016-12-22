//
//  RCSearchResultView.m
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchResultView.h"
#import "RCSearchResultView_Private.h"

#import "RCSearchManager.h"

@implementation RCSearchResultView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addLoadingView];
    }
    return self;
}

- (void)loadItems
{
    [self prepareItems:nil];
    [self startLoadAnimated];
    [self loadinViewHidden:NO];
    [[RCSearchManager shared] result:^(NSArray *array) {
        [self prepareItems:array];
        [self loadinViewHidden:YES];
        [self loadFrameWithKeyBoard];
    }];
}

- (RCSearchCell *)prepareFirstCell:(RCSearchCell *)cell
{
    [cell prepareResultTitle];
    return cell;
}

- (RCSearchCell *)prepareOtherCell:(RCSearchCell *)cell withItem:(id)item
{
    [cell prepareResultItem:item];
    return cell;
}

- (void)didSelectItem:(id)item
{
    [[RCSearchManager shared] didResultItem:item];
}

@end
