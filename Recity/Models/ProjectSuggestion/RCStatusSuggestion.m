//
//  RCStatusSuggestion.m
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCStatusSuggestion.h"

@interface RCStatusSuggestion ()

@property (copy, nonatomic) NSString *projectStatusWhichConfirmed;

@end

@implementation RCStatusSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
       projectStatusWhichConfirmed:(NSString *)projectStatusWhichConfirmed
{
    if(self = [super initWithProjectUID:projectUID]) {
        _projectStatusWhichConfirmed = [projectStatusWhichConfirmed copy];
    }
    return self;
}

- (NSDictionary *)parametersOfSuggestion
{
    return @{kProjectId : self.projectUID,
             kSuggestionType : kStatus,
             kStatusSuggestion : self.projectStatusWhichConfirmed};
}

@end
