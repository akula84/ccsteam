//
//  RecentView+TableView.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchParentView_Private.h"

#import "RCSearchCell.h"

@implementation RCSearchParentView (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCSearchCell *cell = [self cellWithIdentifier];
    
    if ([self isFirstIndex:indexPath]) {
        cell = [self prepareFirstCell:cell];
    } else {
        id item = [self itemForIndexPath:indexPath];
        cell = [self prepareOtherCell:cell withItem:item];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isFirstIndex:indexPath]) {return;}
    id item = [self itemForIndexPath:indexPath];
    [self didSelectItem:item];
}

- (void)didSelectItem:(id)item
{}

- (BOOL)isFirstIndex:(NSIndexPath *)indexPath
{
    return indexPath.row == 0;
}

- (RCSearchCell *)cellWithIdentifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:[self reuseID]];
}

- (id)itemForIndexPath:(NSIndexPath *)path
{
    return self.items[(NSUInteger)path.row - 1];
}

- (RCSearchCell *)prepareFirstCell:(RCSearchCell *)cell 
{
    return cell;
}

- (RCSearchCell *)prepareOtherCell:(RCSearchCell *)cell withItem:(id)item
{
    return cell;
}

@end
