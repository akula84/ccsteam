//
//  RCSuggestTypeTableViewController.m
//  Recity
//
//  Created by ezaji.dm on 06.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionTypeTableViewController.h"

#import "RCSuggestionTableCell.h"

#import "RCSuggestionManagerCreator.h"

@interface RCSuggestionTypeTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) RCSuggestionManagerCreator *suggestionManagerCreator;

@end

@implementation RCSuggestionTypeTableViewController

- (IBAction)back {
    [self close];
}

- (void)configureSuggestionManagerCreatorWithProject:(RCProject *)project {
    self.suggestionManagerCreator = [[RCSuggestionManagerCreator alloc] initWithProject:project];
    self.suggestionManager = [self.suggestionManagerCreator suggestionManagerWithType:RCSelectionManager];
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    RCSuggestionViewController *suggestionVC = segue.destinationViewController;
    RCSuggestionManagerType managerType = RCSelectionManager;
    if([segue.identifier isEqualToString:@"showDevelopmentStatusSuggestion"]) {
        managerType = RCStatusManager;
    } else if([segue.identifier isEqualToString:@"showDevelopmentTenantsSuggestion"]) {
        managerType = RCTenantsManager;
    } else if([segue.identifier isEqualToString:@"showOtherSuggestion"]) {
        managerType = RCOtherManager;
    }
    suggestionVC.suggestionManager = [self.suggestionManagerCreator suggestionManagerWithType:managerType];
}

@end
