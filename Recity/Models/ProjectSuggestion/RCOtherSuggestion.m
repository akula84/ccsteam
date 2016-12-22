//
//  RCOtherSuggestion.m
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCOtherSuggestion.h"

@interface RCOtherSuggestion ()

@property (nonatomic, copy) NSString *textOfSuggestion;

@end

@implementation RCOtherSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
                  textOfSuggestion:(NSString *)textOfSuggestion
{
    if(self = [super initWithProjectUID:projectUID]) {
        _textOfSuggestion = [textOfSuggestion copy];
    }
    return self;
}

- (NSDictionary *)parametersOfSuggestion {
    return @{kProjectId : self.projectUID,
             kSuggestionType : @"other",
             kTextOtherSuggestion : self.textOfSuggestion};
}

@end
