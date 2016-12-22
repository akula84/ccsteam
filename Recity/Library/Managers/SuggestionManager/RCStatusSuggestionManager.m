//
//  RCStatusSuggestionManager.m
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCStatusSuggestionManager.h"
#import "RCSuggestionManager_Private.h"

#import "RCStatusSuggestion.h"

@implementation RCStatusSuggestionManager

- (void)setupSuggestionViewModels
{
    RCSuggestionViewModel *planned = [self modelWithCellID:kPlanned
                                                      name:@"Planned"];
    RCSuggestionViewModel *underConstruction = [self modelWithCellID:kUnderConstruction
                                                                name:@"Under Construction"];
    RCSuggestionViewModel *completed = [self modelWithCellID:kCompleted
                                                        name:@"Recently Completed"];
    
    [self.tmpViewModels addObjectsFromArray:@[planned,
                                              underConstruction,
                                              completed]];
}

- (RCSuggestionViewModel *)modelWithCellID:(NSString *)cellID
                                      name:(NSString *)name
{
    RCSuggestionViewModel *tableViewModel = [[RCSuggestionViewModel alloc] init];
    tableViewModel.cellID = cellID;
    tableViewModel.text = name;
    if([cellID isEqualToString:self.project.status]) {
        tableViewModel.suggestionAction = RCConfirmedAction;
    } else {
        tableViewModel.suggestionAction = RCNoneAction;
    }    
    return tableViewModel;
}

- (RCProjectSuggestion *)suggestion
{
    RCProjectSuggestion *result = nil;
    for(RCSuggestionViewModel *suggestionModel in self.suggestionViewModels) {
        if(suggestionModel.suggestionAction == RCConfirmedAction &&
           ![suggestionModel.cellID isEqualToString:self.project.status]) {
            result = [[RCStatusSuggestion alloc] initWithProjectUID:self.project.uid
                                        projectStatusWhichConfirmed:suggestionModel.cellID];
        }
    }
    return result;
}

@end
