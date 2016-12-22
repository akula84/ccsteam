//
//  RCPlaceholderTextView.h
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RCPlaceholderTextView : UITextView

@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, copy) IBInspectable UIColor *placeholderColor;

@property (assign, nonatomic) BOOL isShowBorder; //default is YES.

@end
