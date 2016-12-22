//
//  RCSearchParentView+KVO.m
//  Recity
//
//  Created by Artem Kulagin on 14.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchParentView_Private.h"

@implementation RCSearchParentView (KVO)

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
    [self loadFrameWithKeyBoard];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
