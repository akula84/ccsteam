//
//  RCTenantsSuggestionTableViewController.m
//  Recity
//
//  Created by ezaji.dm on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTenantsSuggestionTableViewController.h"
#import "RCAdditionalTenantTableCell.h"

#import "RCTenantsSuggestionManager.h"

@interface RCTenantsSuggestionTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tenantsSuggestionTableView;

@end

@implementation RCTenantsSuggestionTableViewController

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.suggestionManager.suggestionViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCSuggestionViewModel *model = [self modelAtIndex:(NSUInteger)indexPath.row];
    
    RCSuggestionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellID];
    cell.model = model;
    
    if([model.cellID isEqualToString:@"addTenants"]) {
        cell.showSeparatedBottom = NO;
        
        @weakify(cell);
        cell.didPressedCellBlock = ^()
        {
            @strongify(cell);
            [((RCAdditionalTenantTableCell *)cell).tenantTextField becomeFirstResponder];
        };
    } else {
        @weakify(self);
        cell.didPressedCellBlock = ^()
        {
            @strongify(self);
            [[self modelAtIndex:(NSUInteger)indexPath.row] changeSuggestionAction];
            [self.tenantsSuggestionTableView reloadData];
        };
    }
    
    return cell;
}

- (RCSuggestionViewModel *)modelAtIndex:(NSUInteger)index
{
    return self.suggestionManager.suggestionViewModels[index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    RCSuggestionTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RUN_BLOCK(cell.didPressedCellBlock);
    [self checkEnableSubmitButton];
}

- (IBAction)okAction {
    RCAdditionalTenantTableCell *additionalTenantTableCell = [self additionalTenantTableCell];
    
    if(additionalTenantTableCell.tenantTextField.text.length > 0) {
        RCSuggestionViewModel *tenantViewModel = [[RCSuggestionViewModel alloc] init];
        tenantViewModel.text = additionalTenantTableCell.tenantTextField.text;
        tenantViewModel.suggestionAction = RCNewAction;
        tenantViewModel.cellID = @"tenants";
        [(RCTenantsSuggestionManager *)self.suggestionManager addNewTenantViewModel:tenantViewModel];
    }
    
    [additionalTenantTableCell.tenantTextField resignFirstResponder];
    [self checkEnableSubmitButton];
    [self.tenantsSuggestionTableView reloadData];
}

- (IBAction)submitAction {
    RCAdditionalTenantTableCell *additionalTenantTableCell = [self additionalTenantTableCell];
    [additionalTenantTableCell.tenantTextField resignFirstResponder];
    [super submitAction];
}

- (IBAction)removeAction:(id)sender {
    RCSuggestionTableCell *cell = (RCSuggestionTableCell *)[[sender superview] superview];
    [(RCTenantsSuggestionManager *)self.suggestionManager removeTenantViewModel:cell.model];
    [self checkEnableSubmitButton];
    [self.tenantsSuggestionTableView reloadData];
}

- (RCAdditionalTenantTableCell *)additionalTenantTableCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:((NSInteger)self.suggestionManager.suggestionViewModels.count - 1)
                                                inSection:0];
    return [self.tenantsSuggestionTableView cellForRowAtIndexPath:indexPath];
}

@end
