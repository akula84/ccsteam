//
//  RCStatusSuggestionTableViewController.m
//  Recity
//
//  Created by ezaji.dm on 07.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCStatusSuggestionTableViewController.h"

#import "RCStatusSuggestion.h"

#import "RCSuggestionTableCell.h"

@interface RCStatusSuggestionTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation RCStatusSuggestionTableViewController

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.suggestionManager.suggestionViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSuggestionViewModel *model = [self modelAtIndex:(NSUInteger)indexPath.row];
    
    RCSuggestionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellID];
    cell.model = model;
    
    if(indexPath.row == ((NSInteger)self.suggestionManager.suggestionViewModels.count - 1)) {
        cell.showSeparatedBottom = NO;
    }
    
    return cell;
}

- (RCSuggestionViewModel *)modelAtIndex:(NSUInteger)index
{
    return self.suggestionManager.suggestionViewModels[index];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    for(NSUInteger numberModel = 0; numberModel < self.suggestionManager.suggestionViewModels.count; numberModel++) {
        RCSuggestionViewModel *model = self.suggestionManager.suggestionViewModels[numberModel];
        if(numberModel == (NSUInteger)indexPath.row) {
            model.suggestionAction = RCConfirmedAction;
        } else {
            model.suggestionAction = RCNoneAction;
        }
    }
    [self checkEnableSubmitButton];
    [tableView reloadData];
}

@end
