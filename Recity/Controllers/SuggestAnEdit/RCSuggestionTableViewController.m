//
//  RCSuggestionTableViewCotroller.m
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionTableViewController.h"

#import "RCMapViewController.h"

@interface RCSuggestionTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RCSuggestionTableViewController

#pragma mark - Navigation
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)close {
    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    UIViewController *popViewController = nil;
    NSEnumerator *reverseEnumerator = nav.viewControllers.reverseObjectEnumerator;
    while((popViewController = reverseEnumerator.nextObject)) {
        if([popViewController isKindOfClass:[RCMapViewController class]]) break;
    }
    [nav slideLayerInDirection:direction_bottom
                        andPop:popViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.suggestionManager countItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuseID = [self cellReuseIdByIndexPath:indexPath];
    RCSuggestionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    [self configureCell:cell
            atIndexPath:indexPath];
    return cell;
}

- (NSString *)cellReuseIdByIndexPath:(NSIndexPath *)indexPath {
    return [self.suggestionManager nameItemByIndex:(NSUInteger)indexPath.row];
}

- (void)configureCell:(RCSuggestionTableCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    cell.imageItem.image = IMG([self.suggestionManager imageNamedByIndex:(NSUInteger)indexPath.row]);
    cell.nameItem.text = [self.suggestionManager nameItemByIndex:(NSUInteger)indexPath.row];
    if(indexPath.row == ((NSInteger)[self.suggestionManager countItem] - 1)) {
        cell.showSeparatedBottom = NO;
    }
}

@end
