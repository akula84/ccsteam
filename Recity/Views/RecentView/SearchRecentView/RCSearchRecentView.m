//
//  SearchRecentView.m
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchRecentView.h"

#import "RCSearchCell.h"
#import "RCSearchManager.h"
#import "RCRecentSearch.h"

@implementation RCSearchRecentView

- (void)loadItems
{
    [self startLoadAnimated];
    [[RCSearchManager shared] recents:^(NSArray *array) {
        [self prepareItems:array];
        [self loadFrameWithKeyBoard];
    }];
}

- (RCSearchCell *)prepareFirstCell:(RCSearchCell *)cell
{
    [cell prepareTitleRecent];
    return cell;
}

- (RCSearchCell *)prepareOtherCell:(RCSearchCell *)cell withItem:(id)item
{
    [cell prepareItemRecent:item];
    return cell;
}

- (void)didSelectItem:(id)item
{
    [[RCSearchManager shared] didRecentText:((RCRecentSearch*)item).text];
}

@end
