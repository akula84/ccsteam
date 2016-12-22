//
//  RCSuggestionManager_Private.h
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionManager.h"
#import "RCSuggestionViewModel.h"

@interface RCSuggestionManager ()

@property (copy, nonatomic, readwrite) NSMutableArray <RCSuggestionViewModel *> *tmpViewModels;

- (void)setupSuggestionViewModels;

@end
