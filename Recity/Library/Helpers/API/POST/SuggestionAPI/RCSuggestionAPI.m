//
//  RCSuggestionAPI.m
//  Recity
//
//  Created by ezaji.dm on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionAPI.h"

@implementation RCSuggestionAPI

- (NSString *)path
{
    return kAPIPostSuggestion;
}

- (NSMutableDictionary *)parameters
{
    return self.object;
}

@end
