//
//  RCMapViewController+NavigationItems.m
//  Recity
//
//  Created by Artem Kulagin on 30.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "RCMapDelegate.h"
#import "RCSearchManager.h"
#import "VKSideMenuController.h"

@implementation RCMapViewController (NavigationItems)

- (IBAction)actionMenu:(id)sender
{
    [VKSideMenuController showMenu];
}

- (IBAction)actionSearch:(id)sender
{
    [self checkPossibleSearch];
}

- (void)actionBackSearch
{
    [self closeSearch];
}

- (void)actionCloseSearch
{
    [RCSearchManager resultClear];
    [self reloadVisibleAddress];
    
    if ([self isSearchTextFieldClear]) {
        [self closeSearch];
    } else {
        [self searchTextFieldClear];
    }
}

- (void)initNavItems
{
    self.menuItem = self.navigationItem.leftBarButtonItem;
    self.searchItem = self.navigationItem.rightBarButtonItem;
}

- (void)visibleSearchNavItems
{
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self cancelBarButtonItem];
}

- (void)visibleDefaultsNavItems
{
    self.navigationItem.leftBarButtonItem = self.menuItem;
    self.navigationItem.rightBarButtonItem = self.searchItem;
}

- (UIBarButtonItem *)backBarButtonItem
{
    UIImage *image = [UIImage imageNamed:@"back"];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(actionBackSearch)];
}

- (UIBarButtonItem *)cancelBarButtonItem
{
    UIImage *image = [UIImage imageNamed:@"cancel"];
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(actionCloseSearch)];
}

@end
