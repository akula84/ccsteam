//
//  RCOtherSuggestionManager.m
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCOtherSuggestionManager.h"
#import "RCSuggestionManager_Private.h"

#import "RCOtherSuggestion.h"

@implementation RCOtherSuggestionManager

- (void)setupSuggestionViewModels
{
    RCSuggestionViewModel *otherViewModel = [[RCSuggestionViewModel alloc] init];
    otherViewModel.text = @"";
    [self.tmpViewModels addObject:otherViewModel];
}

- (RCProjectSuggestion *)suggestion
{
    RCProjectSuggestion *result = nil;
    RCSuggestionViewModel *otherViewModel = self.suggestionViewModels[0];
    if(otherViewModel.text.length > 0) {
        result = [[RCOtherSuggestion alloc] initWithProjectUID:self.project.uid
                                              textOfSuggestion:otherViewModel.text];
    }
    return result;
}

@end
