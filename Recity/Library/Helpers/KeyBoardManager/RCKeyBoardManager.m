//
//  RCKeyBoardManager.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCKeyBoardManager.h"

@interface RCKeyBoardManager ()

@property (assign, nonatomic, readwrite) BOOL showKeyboard;

@end

@implementation RCKeyBoardManager
SINGLETON_OBJECT

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserverKeyboard];
    }
    return self;
}

- (void)addObserverKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calculateKeyBoardTop:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calculateKeyBoardTop:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)calculateKeyBoardTop:(NSNotification *)notification
{
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        self.showKeyboard = YES;
    } else if([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        self.showKeyboard = NO;
    }
    NSDictionary *info = [notification userInfo];
    self.currentKeyBoardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
