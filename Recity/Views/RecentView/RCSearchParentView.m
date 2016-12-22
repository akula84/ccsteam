//
//  RecentView.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchParentView.h"
#import "RCSearchParentView_Private.h"

#import "RCSearchCell.h"

@implementation RCSearchParentView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addObserverKeyboard];
        [self registerCell];
        [self hideEmptySeparators];
    }
    return self;
}

- (void)hideEmptySeparators
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
}

- (void)registerCell
{
    UINib *nib = [UINib nibWithNibName:[self reuseID] bundle: nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:[self reuseID]];
}

- (void)loadItems{}

- (void)prepareItems:(NSArray *)array
{
     self.items = array;
    [self.tableView reloadData];
}

- (NSString *)reuseID
{
    return [RCSearchCell rc_className];
}

- (NSString *)nibNamed
{
    return NSStringFromClass([RCSearchParentView class]);
}

@end
