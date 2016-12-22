//
//  RCOtherSuggestion.h
//  Recity
//
//  Created by ezaji.dm on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectSuggestion.h"

@interface RCOtherSuggestion : RCProjectSuggestion

- (instancetype)initWithProjectUID:(NSNumber *)projectUID
                  textOfSuggestion:(NSString *)textOfSuggestion;

@end
