//
//  RCProjectSuggestion.m
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectSuggestion.h"

@implementation RCProjectSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
{
    if(self = [super init]) {
        _projectUID = projectUID;
    }
    return self;
}

- (NSDictionary *)parametersOfSuggestion
{
    THROW_MISSED_IMPLEMENTATION_EXCEPTION
}

@end
