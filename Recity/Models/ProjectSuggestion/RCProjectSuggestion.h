//
//  RCProjectSuggestion.h
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProject.h"

@interface RCProjectSuggestion : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithProjectUID:(NSNumber *)projectUID NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSNumber *projectUID;

- (NSDictionary *)parametersOfSuggestion;

@end
