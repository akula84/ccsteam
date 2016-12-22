//
//  RCStatusSuggestion.h
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectSuggestion.h"

@interface RCStatusSuggestion : RCProjectSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
       projectStatusWhichConfirmed:(NSString *)projectStatusWhichConfirmed;

@end
