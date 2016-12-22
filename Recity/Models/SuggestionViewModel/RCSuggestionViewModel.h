//
//  RCSuggestionViewModel.h
//  Recity
//
//  Created by ezaji.dm on 29.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RCSuggestionAction) {
    RCNotValidAction    = -1,
    RCNoneAction        = 0,
    RCConfirmedAction   = 1,
    RCRejectedAction    = 2,
    RCNewAction         = 3
};

@interface RCSuggestionViewModel : NSObject

/*
 * @discussion Image is set nil, if new suggestionAction == RCNotValidAction.
 *             Image is set corresponding picture, if new suggestionAction != RCNotValidAction.
 */
@property (assign, nonatomic) RCSuggestionAction suggestionAction;
@property (copy, nonatomic) NSString *text;

@property (strong, nonatomic) UIImage *image;

@property (copy, nonatomic) NSString *cellID;

- (void)changeSuggestionAction;

- (NSString *)stringForSuggestionAction;

@end
