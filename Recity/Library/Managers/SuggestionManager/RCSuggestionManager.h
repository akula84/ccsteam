//
//  RCSuggestionManager.h
//  Recity
//
//  Created by ezaji.dm on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCProjectSuggestion.h"

@class RCSuggestionViewModel;

@interface RCSuggestionManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProject:(RCProject *)project NS_DESIGNATED_INITIALIZER;

@property (copy, nonatomic, readonly) NSArray <RCSuggestionViewModel *> *suggestionViewModels;

@property (nonatomic, readonly) RCProject *project;

- (BOOL)isSubmitSuggestion;
- (RCProjectSuggestion *)suggestion;

@end
