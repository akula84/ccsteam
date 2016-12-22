//
//  Created by Denis Matveev on 18/02/16.
//

#import "BaseComfortTextInput.h"
#import "FreeSpaceLongTouchDetector.h"

@interface BaseComfortTextInput ()

@property (strong, nonatomic) FreeSpaceLongTouchDetector *tapDetector;

@end

@implementation BaseComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView {
    self = [super init];
    if (self) {
        self.ownerView = ownerView;
        _ownerViewStartFrame = ownerView.frame;
        _hideKeyboardOnTapOutside = YES;
        for (NSInteger i = 0; i < orderedTextInputControls.count - 1; ++i) {
            id<UITextInputTraits> control = orderedTextInputControls[i];
            control.returnKeyType = UIReturnKeyNext;
        }
        id<UITextInputTraits> lastControl = orderedTextInputControls[orderedTextInputControls.count - 1];
        lastControl.returnKeyType = UIReturnKeyDone;
        
        for (id currentControl in orderedTextInputControls) {
            if ([currentControl isKindOfClass:[UITextField class]]) {
                UITextField *textField = currentControl;
                textField.delegate = self;
            } else if ([currentControl isKindOfClass:[UITextView class]]) {
                UITextView *textView = currentControl;
                textView.delegate = self;
            }
        }
        self.orderedTextInputControls = orderedTextInputControls;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction) name:UIKeyboardWillHideNotification object:nil];
        
        _tapDetector = [FreeSpaceLongTouchDetector new];
        _tapDetector.minimumRequiredPressDuration = @(0);
        [_tapDetector attachToTargetView:ownerView];
        __typeof__(self) __weak wself = self;
        _tapDetector.didFinishedWithTouchUpAtTargetViewLocationBlock = ^(CGPoint point) {
            CGPoint tappedScreenPoint = [wself.ownerView convertPoint:point toView:nil];
//            NSLog(@"POINT %@ TRANSLATED %@",NSStringFromCGPoint(point),NSStringFromCGPoint(tappedScreenPoint));
//            for (UITextField *currentTextField in wself.orderedTextFields) {
//                CGRect translatedRect = [currentTextField viewFrameAtScreenCoordinates];
//                NSLog(@"current textfield text %@ translated to window rect %@",currentTextField.text,NSStringFromCGRect(translatedRect));
//            }
            if ([wself.ownerView hasFirstResponder]) {
                if (wself.hideKeyboardOnTapOutside) {
                    BOOL someTextFieldContainsPoint = NO;
                    for (UITextField *currentTextField in wself.orderedTextInputControls) {
                        CGRect textFieldScreenFrame = [currentTextField viewFrameAtScreenCoordinates];
                        if (CGRectContainsPoint(textFieldScreenFrame, tappedScreenPoint)) {
                            someTextFieldContainsPoint = YES;
                            break;
                        }
                    }
                    if (!someTextFieldContainsPoint) {
                        [wself hideKeyboard];
                    }
                }
            }
        };

    }
    return self;
}

- (void)resetWithResignFirstResponder {
    [self turnToInitialState];//        you should rewrite it in subclasses
    [self hideKeyboard];
}

- (void)keyboardWillHideAction {
    [self turnToInitialState];
}

- (void)turnToInitialState {
    [self setOwnerViewYanimated:self.ownerViewStartFrame.origin.y];
}

- (void)setOwnerViewYanimated:(CGFloat)newY {
    [self performActionsAnimated:^{
        self.ownerView.y = newY;
    }];
}

- (void)performActionsAnimated:(dispatch_block_t)block {
    
    [UIView animateWithDuration:[[KeyboardInfo sharedInstance] keyboardAnimationTimeInterval] delay:0 options:[[KeyboardInfo sharedInstance] keyboardAnimationCurve] animations:^{
        RUN_BLOCK(block);
    } completion:nil];
}

- (void)hideKeyboard {
    [self.ownerView endEditing:YES];
}

#pragma mark - UITextFieldDelegate DELEGATE

- (void)textFieldWillBeginEditing:(UITextField *)textField {
    //      should be rewritten in subclass
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self textFieldWillBeginEditing:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textInputControlDidEndEditingBlock) {
        self.textInputControlDidEndEditingBlock(textField);
    }
}

#pragma mark - UITextViewDelegate DELEGATE

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //      should be rewritten in subclass
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self textViewDidBeginEditing:textView];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textInputControlDidEndEditingBlock) {
        self.textInputControlDidEndEditingBlock(textView);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
