//
//  RCSuggestionManagerCreator.m
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionManagerCreator.h"

#import "RCSelectionSuggestionManager.h"
#import "RCStatusSuggestionManager.h"
#import "RCTenantsSuggestionManager.h"
#import "RCOtherSuggestionManager.h"

@interface RCSuggestionManagerCreator ()

@property (nonatomic) NSMutableDictionary <NSNumber *, RCSuggestionManager *> *suggestionManagers;
@property (nonatomic, readonly) RCProject *project;

@end

@implementation RCSuggestionManagerCreator

- (instancetype)initWithProject:(RCProject *)project
{
    if(self = [super init]) {
        _project = project;
        _suggestionManagers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (RCSuggestionManager *)suggestionManagerWithType:(RCSuggestionManagerType)managerType
{
    RCSuggestionManager *result = self.suggestionManagers[@(managerType)];
    if(!result) {
        Class managerClass = [self classManagerIsCreatedWithType:managerType];
        result = [[managerClass alloc] initWithProject:self.project];
        [self.suggestionManagers setObject:result
                                    forKey:@(managerType)];
    }
    return result;
}

- (Class)classManagerIsCreatedWithType:(RCSuggestionManagerType)managerType
{
    Class result = nil;
    switch (managerType) {
        case RCSelectionManager:
            result = [RCSelectionSuggestionManager class];
            break;
        case RCStatusManager:
            result = [RCStatusSuggestionManager class];
            break;
        case RCTenantsManager:
            result = [RCTenantsSuggestionManager class];
            break;
        case RCOtherManager:
            result = [RCOtherSuggestionManager class];
            break;
    }
    return result;
}

@end
