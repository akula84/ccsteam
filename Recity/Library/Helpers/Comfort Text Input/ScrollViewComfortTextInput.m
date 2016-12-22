//
//  Created by Denis Matveev on 18/02/16.
//

#import "ScrollViewComfortTextInput.h"

@interface ScrollViewComfortTextInput ()

@property (assign, nonatomic) CGSize scrollViewStartContentSize;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL scrollViewContentSizeChanged;

@end

@implementation ScrollViewComfortTextInput

- (instancetype)initWithOrderedTextInputControls:(NSArray *)orderedTextInputControls withOwnerView:(UIView *)ownerView withScrollViewInsideOwnerViewWhereTextFieldsLocated:(UIScrollView *)scrollView {
    self = [super initWithOrderedTextInputControls:orderedTextInputControls withOwnerView:ownerView];
    if (self) {
        _scrollViewStartContentSize = scrollView.contentSize;
        _scrollView = scrollView;
    }
    return self;
}

- (void)resetWithResignFirstResponder {
    [super resetWithResignFirstResponder];
    _scrollView.contentSize = _scrollViewStartContentSize;
    _scrollViewContentSizeChanged = NO;
}

- (void)setScrollViewContentOffsetY:(CGFloat)newY {
    @weakify(self)
    [self performActionsAnimated:^{
        @strongify(self)
        UIScrollView *scrollView = self.scrollView;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, newY);
    }];
}

- (void)turnToInitialState {
    [super turnToInitialState];
    @weakify(self)
    [self performActionsAnimated:^{
        @strongify(self)
        UIScrollView *scrollView = self.scrollView;
        scrollView.contentSize = self->_scrollViewStartContentSize;
        self.scrollViewContentSizeChanged = NO;
    }];
}

#pragma mark - UITextFieldDelegate DELEGATE

- (void)textFieldWillBeginEditing:(UITextField *)textField {
    [self textInputControlWillBeginEditing:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL result = NO;
    NSUInteger index = [self.orderedTextInputControls indexOfObject:textField];
    if (index != NSNotFound) {
        if (index != self.orderedTextInputControls.count - 1) {
            if (self.textInputControlDidEndEditingBlock) {
                self.textInputControlDidEndEditingBlock(textField);
            }
            UITextField *nextTextField = [self.orderedTextInputControls objectAtIndex:index + 1];
            [nextTextField becomeFirstResponder];
        } else {
            if (self.lastTextInputControlDidEndEditingBlock) {
                self.lastTextInputControlDidEndEditingBlock(textField);
            }
            result = YES;
            [self turnToInitialState];
            [textField resignFirstResponder];
            if (_scrollViewContentSizeChanged) {
                [self performActionsAnimated:^{
                    self->_scrollView.contentSize = self->_scrollViewStartContentSize;
                }];
                _scrollViewContentSizeChanged = NO;
            }
        }
    }
    __unused CGFloat textFieldScreenYPosition = [textField viewOriginAtScreenCoordinates].y;
    NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

#pragma mark - UITextViewDelegate DELEGATE

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textInputControlWillBeginEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL result = YES;
    if ([text isEqualToString:@"\n"]) {
        result = NO;
        [self textInputControlShouldReturn:textView];//     here returned result useless for us
    }
    return result;
}

#pragma mark - Private

- (void)textInputControlWillBeginEditing:(UIView *)textInputControl {
    CGFloat mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat keyboardHeight = [[KeyboardInfo sharedInstance] keyboardHeight];
    
    //      will center text field on free space
    CGFloat freeHeightFromOwnerViewTopToKeyboardTop = mainScreenHeight - self.ownerViewStartFrame.origin.y - keyboardHeight;
    
    UIScrollView *scrollView = self.scrollView;
    
    CGFloat scrollViewTopYinsideOwnerView = [scrollView viewOriginAtViewCoordinates:self.ownerView].y;
    
    //      so raise ownerView for scrollView become stay on top
    CGFloat ownerViewNewTopY = self.ownerViewStartFrame.origin.y - scrollViewTopYinsideOwnerView;
    
    CGFloat increaseContentHeightForScrollView = scrollView.height - freeHeightFromOwnerViewTopToKeyboardTop;
    if (!_scrollViewContentSizeChanged) {
        if (increaseContentHeightForScrollView > 0) {
            CGSize contentSize = scrollView.contentSize;
            contentSize.height += increaseContentHeightForScrollView;
            scrollView.contentSize = contentSize;
            _scrollViewContentSizeChanged = YES;
        }
    }
    
    CGFloat textFieldYtranslatedToScrollView = [textInputControl viewOriginAtViewCoordinates:scrollView].y;//     bcs it may be textfield inside UITableViewCell, so weneed translate coordinates of it
    CGFloat newContentOffsetY = textFieldYtranslatedToScrollView - (freeHeightFromOwnerViewTopToKeyboardTop/2.0f) + (textInputControl.height / 2.0f);
    CGFloat maximumContentOffsetY = scrollView.contentSize.height - scrollView.height;
    if (newContentOffsetY < 0) {
        newContentOffsetY = 0;
    }
    if (newContentOffsetY > maximumContentOffsetY) {
        newContentOffsetY = maximumContentOffsetY;
    }
    
    [self performActionsAnimated:^{
        self.ownerView.y = ownerViewNewTopY;//        set y of owner view so, that scrollView will has Y screen coordinate as 0 (that is, we can see top of scrollView frame)
        scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, newContentOffsetY);
    }];
}

- (BOOL)textInputControlShouldReturn:(UIView *)textInputControl {
    BOOL result = NO;
    NSUInteger index = [self.orderedTextInputControls indexOfObject:textInputControl];
    if (index != NSNotFound) {
        if (index != self.orderedTextInputControls.count - 1) {
            if (self.textInputControlDidEndEditingBlock) {
                self.textInputControlDidEndEditingBlock(textInputControl);
            }
            UITextField *nextTextField = [self.orderedTextInputControls objectAtIndex:index + 1];
            [nextTextField becomeFirstResponder];
        } else {
            if (self.lastTextInputControlDidEndEditingBlock) {
                self.lastTextInputControlDidEndEditingBlock(textInputControl);
            }
            result = YES;
            [self turnToInitialState];
            [textInputControl resignFirstResponder];
            if (_scrollViewContentSizeChanged) {
                [self performActionsAnimated:^{
                    self->_scrollView.contentSize = self->_scrollViewStartContentSize;
                }];
                _scrollViewContentSizeChanged = NO;
            }
        }
    }
    __unused CGFloat textFieldScreenYPosition = [textInputControl viewOriginAtScreenCoordinates].y;
    NSLog(@"after textField screen coordinates %f",textFieldScreenYPosition);
    
    return result;
}

@end
