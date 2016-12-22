//
//  Created by Denis Matveev on 18/02/16.
//

#import "KeyboardInfo.h"

@interface KeyboardInfo () {
    NSDictionary *_keyboardInfo;
    
    NSTimeInterval _keyboardAnimationTimeInterval;
    CGFloat _keyboardHeight;
    UIViewAnimationOptions _keyboardAnimationCurve;
    BOOL _keyboardInfoGathered;
}
@end

@implementation KeyboardInfo

#pragma mark - Class

+ (KeyboardInfo *)sharedInstance {
    static dispatch_once_t once;
    static KeyboardInfo *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[KeyboardInfo alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Life

- (id)init {
    self = [super init];
    if (self) {
        _keyboardInfoGathered = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

#pragma mark - Public

- (void)prepareKeyboardWithMainWindow:(UIWindow *)window {
    UITextField *lagFreeField = [[UITextField alloc] init];
    [window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}

- (NSTimeInterval)keyboardAnimationTimeInterval {
    return _keyboardAnimationTimeInterval;
}

- (CGFloat)keyboardHeight {
    return _keyboardHeight;
}

- (UIViewAnimationOptions)keyboardAnimationCurve {
    return _keyboardAnimationCurve;
}

- (BOOL)keyboardInfoGathered {
    return _keyboardInfoGathered;
}

#pragma mark - UIKeyboard Notifications

- (void)keyboardNotification:(NSNotification*)notification {
    _keyboardInfoGathered = YES;
    
    _keyboardInfo = [notification userInfo];
    NSTimeInterval timeInterval = 0;
    NSNumber *keyboardAnimationTimeInterval = [_keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    timeInterval = [keyboardAnimationTimeInterval doubleValue];
    if (timeInterval > 0.01) {
        _keyboardAnimationTimeInterval = timeInterval;//        we wants to know real duration (which is always greater than zero)
    }
    
    NSValue *keyboardFrameBeginValue = [_keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBegin;
    [keyboardFrameBeginValue getValue:&keyboardFrameBegin];
    if (keyboardFrameBegin.size.height > 1) {//     no save when it will became 0 (when keyboard will hidden)
        _keyboardHeight = keyboardFrameBegin.size.height;
    }
    
    NSNumber *keyboardAnimationCurve = [_keyboardInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    _keyboardAnimationCurve = [keyboardAnimationCurve unsignedIntegerValue];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
