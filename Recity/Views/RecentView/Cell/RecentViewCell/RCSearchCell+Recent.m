//
//  RCSearchCell+Recent.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchCell.h"
#import "RCSearchCell_Private.h"

#import "RCRecentSearch.h"

@implementation RCSearchCell (Recent)

- (void)prepareTitleRecent
{
    [self prepareAllHide];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleRecent.hidden = NO;
}

- (void)prepareItemRecent:(RCRecentSearch *)item
{
    [self prepareAllHide];
    [self prepareImage:@"searchRecent"];
    [self prepareCenterLabelText:item.text];
}

@end
