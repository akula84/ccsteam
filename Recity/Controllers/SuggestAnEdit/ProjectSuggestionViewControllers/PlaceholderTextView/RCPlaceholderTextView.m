//
//  RCPlaceholderTextView.m
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCPlaceholderTextView.h"

@interface RCPlaceholderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end

@implementation RCPlaceholderTextView

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) )
    {
        _isShowBorder = YES;
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [self setupObserve];
        [self setupBorder];
    }
    return self;
}

- (void)setupObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [self setupObserve];
    
    _isShowBorder = YES;
    [self setupBorder];
}

- (void)setupBorder
{
    if(self.isShowBorder) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = RGB(230, 230, 230).CGColor;
    } else {
        self.layer.borderWidth =  0.0f;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)setIsShowBorder:(BOOL)isShowBorder
{
    _isShowBorder = isShowBorder;
    [self setupBorder];
}

- (void)textChanged:(NSNotification *)notification {
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         if([[self text] length] == 0) {
                             [[self viewWithTag:999] setAlpha:1];
                         } else {
                             [[self viewWithTag:999] setAlpha:0];
                         }
                     }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    UILabel *placeholderLabel = self.placeHolderLabel;
    if(self.placeholder.length > 0) {
        if (placeholderLabel == nil) {
            placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeholderLabel.numberOfLines = 0;
            placeholderLabel.font = self.font;
            placeholderLabel.backgroundColor = [UIColor clearColor];
            placeholderLabel.textColor = self.placeholderColor;
            placeholderLabel.alpha = 0;
            placeholderLabel.tag = 999;
            [self addSubview:placeholderLabel];
        }
        
        placeholderLabel.text = self.placeholder;
        [placeholderLabel sizeToFit];
        [self sendSubviewToBack:placeholderLabel];
    }
    
    if(self.text.length == 0 && self.placeholder.length > 0) {
        [[self viewWithTag:999]
         setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
