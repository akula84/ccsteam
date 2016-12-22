//
//  RCMenuTableView.m
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMenuTableView.h"

#import "RCLeftMenuCell.h"

@interface RCMenuTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSArray *items;

@end

@implementation RCMenuTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)prepareItems:(NSArray *)items
{
    self.items = items;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (NSInteger)self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.items[(NSUInteger)section];
    return (NSInteger)sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCLeftMenuCell *cell = [self cellWithIdentifier];
    RCVKSideMenuItem *item = [self itemForIndexPath:indexPath];
    [cell setItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PERFORM_BLOCK_IF_NOT_NIL(self.didSelect, indexPath);
}

- (RCLeftMenuCell *)cellWithIdentifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:[self reuseID]];
}

- (RCVKSideMenuItem *)itemForIndexPath:(NSIndexPath *)path
{
    NSArray *sectionArray = self.items[(NSUInteger)path.section];
    return sectionArray[(NSUInteger)path.row];
}

- (NSString *)reuseID
{
    return [RCLeftMenuCell rc_className];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 9.f;
    if (section == 0) {height = height + 1;}
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.f;
}

@end
