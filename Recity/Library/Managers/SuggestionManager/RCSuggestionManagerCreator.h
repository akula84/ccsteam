//
//  RCSuggestionManagerCreator.h
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCSuggestionManager.h"

typedef NS_ENUM(NSInteger, RCSuggestionManagerType) {
    RCSelectionManager  = 0,
    RCStatusManager     = 1,
    RCTenantsManager    = 2,
    RCOtherManager      = 3
};

@interface RCSuggestionManagerCreator : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProject:(RCProject *)project NS_DESIGNATED_INITIALIZER;

- (RCSuggestionManager *)suggestionManagerWithType:(RCSuggestionManagerType)managerType;

@end
