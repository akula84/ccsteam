//
//  RCSuggestionViewModel.m
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionViewModel.h"

@implementation RCSuggestionViewModel

- (instancetype)init
{
    if(self = [super init]) {
        _suggestionAction = RCNotValidAction;
    }
    return self;
}

- (void)setSuggestionAction:(RCSuggestionAction)suggestionAction
{
    UIImage *result = nil;
    switch (suggestionAction) {
        case RCNotValidAction:
            break;
        case RCNoneAction:
            result = [Utils circleImageWithRadius:17.5f
                                      borderWidth:1.25f
                                      borderColor:RGB(125, 125, 125)];
            break;
        case RCConfirmedAction:
            result = [Utils circleImageWithRadius:17.5f
                                  backgroundColor:RGB(46, 49, 146)
                                            image:IMG(@"confirm_suggestion")];
            break;
        case RCRejectedAction:
            result =[Utils circleImageWithRadius:17.5f
                                 backgroundColor:RGB(46, 49, 146)
                                           image:IMG(@"reject_suggestion")];
            break;
        case RCNewAction:
            result = [Utils circleImageWithRadius:17.5f
                                  backgroundColor:RGB(46, 49, 146)
                                            image:IMG(@"add_suggestion")];
            break;
    }
    
    _suggestionAction = suggestionAction;
    self.image = result;
}

- (void)changeSuggestionAction
{
    switch (self.suggestionAction) {
        case RCNoneAction:
            self.suggestionAction = RCConfirmedAction;
            break;
        case RCConfirmedAction:
            self.suggestionAction = RCRejectedAction;
            break;
        case RCRejectedAction:
            self.suggestionAction = RCNoneAction;
        default:
            break;
    }
}

- (NSString *)stringForSuggestionAction
{
    NSString *result = nil;
    switch (self.suggestionAction) {
        case RCConfirmedAction:
            result = @"confirmed";
            break;
        case RCRejectedAction:
            result = @"rejected";
            break;
        case RCNewAction:
            result = @"newTenant";
            break;
        default:
            break;
    }
    return result;
}

@end
