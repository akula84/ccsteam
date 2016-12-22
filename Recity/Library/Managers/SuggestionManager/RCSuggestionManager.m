//
//  RCSuggestionManager.m
//  Recity
//
//  Created by ezaji.dm on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionManager_Private.h"

@implementation RCSuggestionManager

- (instancetype)initWithProject:(RCProject *)project
{
    if(self = [super init]) {
        _project = project;
        _tmpViewModels = [NSMutableArray array];
        [self setupSuggestionViewModels];
    }
    return self;
}

- (NSArray <RCSuggestionViewModel *> *)suggestionViewModels
{
    return [self.tmpViewModels copy];
}

- (BOOL)isSubmitSuggestion
{
    return [self suggestion] != nil;
}

- (RCProjectSuggestion *)suggestion
{
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

- (void)setupSuggestionViewModels
{
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

@end
