//
//  RCMapViewController+SearchDelegate.m
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCSearchManager.h"

@implementation RCMapViewController (SearchDelegate)

- (void)initSearchDelegate
{
    [RCSearchManager shared].delegate = self;
}

- (void)searchManager:(RCSearchManager *)searchManager didRecentText:(NSString *)text
{
    [self searchTextFieldText:text];
}

- (void)searchManager:(RCSearchManager *)searchManager showItem:(id)item
{
    [self closeSearch];
    [self showItem:item];
    [self prepareTitleFromItem:item];
}

@end
