//
//  RCMapViewController+TextField.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "CGRect+Utils.h"
#import "UIFont+RecityFont.h"
#import "UIColor+RCColor.h"
#import "NSObject+isFull.h"
#import "RCSearchManager.h"
#import "NSObject+isFull.h"

@import MapKit;

@implementation RCMapViewController (TextField)

- (void)addSearchTextField
{
    UINavigationBar *navigationBar = [self navigationBar];
    [navigationBar addSubview:[self prepareTextField]];
    [self searchTextFieldBecomeFirstResponder];
}

- (UITextField *)prepareTextField
{
    if (!self.searchTextField) {
        CGRect bounds = [self boundsNavigationBar];
        bounds = CGRectSetX(bounds,offsetXCursor);
        bounds = CGRectSetWidth(bounds,CGRectGetWidth(bounds) - 2 * offsetXCursor);
        UITextField *textField = [[UITextField alloc] initWithFrame:bounds];
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor purpleRCColor];
        textField.font = [UIFont flamaBook13];
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        self.searchTextField = textField;
    }
    return  self.searchTextField;
}

- (void)searchTextFieldText:(NSString *)text
{
    self.searchTextField.text = text;
    [self textFieldValueChanged:self.searchTextField];
}

- (void)searchTextFieldCheckHaveText
{
    [self searchTextFieldText:[RCSearchManager shared].searchText];
}

- (void)removeSearchTextField
{
    [self.searchTextField removeFromSuperview];
}

- (void)searchTextFieldBecomeFirstResponder
{
    [self animationKeyBoard:^{
        [self.searchTextField becomeFirstResponder];
    }];
}

- (void)searchTextFieldResignFirstResponder
{
    [self animationKeyBoard:^{
        [self.searchTextField resignFirstResponder];
    }];
}

- (void)animationKeyBoard:(void(^)(void))completion
{
    [UIView animateWithDuration:kKeyBoardAnimation
                          delay:0.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{completion();}
                     completion:nil];
}

- (void)textFieldValueChanged:(UITextField *)sender
{
    if ([self isSearchHaveThreeSymbols]) {
        [[RCSearchManager shared] prepareSearchText:sender.text centerCoordinate:[self.mapView centerCoordinate]];
        [self resultViewShow];
        [self searchTextFieldSearch];
    } else {
        [self recentViewShow];
        [self searchTextFieldReturn];
    }
}

- (BOOL)isSearchHaveThreeSymbols
{
    NSString *text = self.searchTextField.text;
    return text.length >= 3;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
    return YES;
}

- (BOOL)isSearchTextFieldClear
{
    return ![self.searchTextField.text isFull];
}

- (void)searchTextFieldClear
{
    [self searchTextFieldText:@""];
}

- (void)searchTextFieldReturn
{
    [self setReturnKey:UIReturnKeyDefault];
}

- (void)searchTextFieldSearch
{
    [self setReturnKey:UIReturnKeySearch];
}

- (void)setReturnKey:(UIReturnKeyType)returnKeyType
{
    UITextField *textField = self.searchTextField;
    textField.returnKeyType = returnKeyType;
    [textField reloadInputViews];
}

@end
