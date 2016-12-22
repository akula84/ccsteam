//
//  VKSideMenu.m
//
//  Created by Vladislav Kovalyov on 2/7/16.
//  Copyright © 2016 WOOPSS.com (http://woopss.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VKSideMenu.h"

#import "VKSideMenu_Private.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]
/*
@implementation VKSideMenuItem

@synthesize icon;
@synthesize title;
@synthesize tag;

@end
*/
@interface VKSideMenu() //<UITableViewDelegate, UITableViewDataSource>
{
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) UIView *overlay;


/*!
 @method    initWithWidth:andDirection:
 @abstract  Used for initialization of <code>VKSideMenu</code> with specified width and direction
 @param     width
 Specified width of the side menu
 @param     direction
 Specified direction of the side menu
 @see       <code>VKSideMenuDirection</code>
 @return    <code>VKSideMenu</code> instance
 */
-(instancetype)initWithWidth:(CGFloat)width andDirection:(VKSideMenuDirection)direction;

/*!
 @property  delegate
 @abstract  <code>VKSideMenu</code> delegate object
 @see       VKSideMenuDelegate
 */
@property (nonatomic, strong) id <VKSideMenuDelegate> delegate;

/*!
 @property  direction
 @abstract  Direction of the <code>VKSideMenu</code>
 @note      Default is VKSideMenuDirectionLeftToRight
 @see       VKSideMenuDirection enum
 */
@property (nonatomic, assign) VKSideMenuDirection direction;

/*!
 @property  width
 @abstract  Specified width of <code>VKSideMenu</code>
 @note      Default is 240
 */
@property (nonatomic, assign) CGFloat width;

/*!
 @property  blurEffectStyle
 @abstract  UIBlurEffectStyle for <code>VKSideMenu</code> view
 @note      Use if iOS version is 8.0 or later. Default is UIBlurEffectStyleExtraLight
 */
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle NS_AVAILABLE_IOS(8_0);

/*!
 @property  tableView
 @abstract  UITableView object used for data representation
 */
@property (nonatomic, strong) UITableView *tableView;

/*!
 @property  enableOverlay
 @abstract  Determines if dimmed overlay must be showed
 @note      Default value is YES
 */
@property (nonatomic, assign) BOOL enableOverlay;

/*!
 @property  enableOverlay
 @abstract  Determines if <code>VKSideMenu</code> should be closed after user tapped outside the menu view
 @note      Default value is YES
 */
@property (nonatomic, assign) BOOL automaticallyDeselectRow;

/*!
 @property  enableOverlay
 @abstract  Determines if <code>VKSideMenu</code> should be closed after user selected any item
 @note      Default value is YES
 */
@property (nonatomic, assign) BOOL hideOnSelection;

/*!
 @method    show
 @abstract  Shows <code>VKSideMenu</code> view
 */

/*!
 @property   backgroundColor
 @abstract   Color of selection for <code>tableView</code> rows
 @note       Default is colorWithWhite:1. alpha:.8
 @discussion Use only with iOS 7
 */
@property (nonatomic, strong) UIColor *backgroundColor NS_DEPRECATED_IOS(7_0, 8_0);

/*!
 @property  selectionColor
 @abstract  Color of selection for <code>tableView</code> rows
 @note      Default is colorWithWhite:1. alpha:.5
 */
@property (nonatomic, strong) UIColor *selectionColor;

/*!
 @property  selectionColor
 @abstract  Color of title for <code>tableView</code> rows
 @note      Default is #252525
 */
@property (nonatomic, strong) UIColor *textColor;

/*!
 @property  sectionTitleFont
 @abstract  Font for item's title of <code>tableView</code> sections
 @note      Default is systemFont with size 15.0
 */
@property (nonatomic, strong) UIFont *sectionTitleFont;

/*!
 @property  sectionTitleColor
 @abstract  Color of section's title for <code>tableView</code> rows
 @note      Default is #8f8f8f
 */
@property (nonatomic, strong) UIColor *sectionTitleColor;

/*!
 @property  iconsColor
 @abstract  Color of section's icons for <code>tableView</code> rows
 @note      Default is #8f8f8f. Set nil if you don't want to override icon color
 */
@property (nonatomic, strong) UIColor *iconsColor;

@end

@implementation VKSideMenu

- (void)prepareItems:(NSArray *)items
{
    self.items = items;
}

-(instancetype)init
{
    if (self = [super init]){
        [self baseInit];
    }
    return self;
}

-(instancetype)initWithWidth:(CGFloat)width andDirection:(VKSideMenuDirection)direction
{
    if ((self = [super init]))
    {
        [self baseInit];
        
        self.width      = width;
        self.direction  = direction;
    }
    
    return self;
}

-(void)baseInit
{
    self.width                      = 220;
    self.direction                  = VKSideMenuDirectionLeftToRight;
    self.enableOverlay              = YES;
    self.automaticallyDeselectRow   = YES;
    self.hideOnSelection            = YES;
    
    self.sectionTitleFont   = [UIFont systemFontOfSize:15.f];
    self.selectionColor     = [UIColor colorWithWhite:1.f alpha:.5f];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.backgroundColor    = [UIColor colorWithWhite:1.f alpha:.8f];
#pragma clang diagnostic pop
    self.textColor          = UIColorFromRGB(0x252525);
    self.iconsColor         = UIColorFromRGB(0x8f8f8f);
    self.sectionTitleColor  = UIColorFromRGB(0x8f8f8f);
    
    if(!SYSTEM_VERSION_LESS_THAN(@"8.0"))
        self.blurEffectStyle = UIBlurEffectStyleExtraLight;
}

- (void)addGestureLeft
{
    [self.view addGestureRecognizer:[self leftGesture] ];
    [self.overlay addGestureRecognizer:[self leftGesture]];
}

- (UISwipeGestureRecognizer *)leftGesture
{
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    return leftRecognizer;
}

- (void)leftSwipeHandle
{
    [self hide:nil];
}

-(void)initViews
{
    self.overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlay.alpha = 0;
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (self.enableOverlay)
        self.overlay.backgroundColor = [UIColor colorWithWhite:0.f alpha:.4f];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.overlay addGestureRecognizer:tapGesture];
    
    CGRect frame = [self frameHidden];
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        self.view = [[UIView alloc] initWithFrame:frame];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.view.backgroundColor = self.backgroundColor;
#pragma clang diagnostic pop
    }
    else
    {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        self.view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.view.frame = frame;
    }
 
    [self prepareViews];
}

-(void)showIn:(UIViewController *)vc
{
    [self initViews];
    
    [vc.view addSubview:self.overlay];
    [vc.view addSubview:self.view];
    [self addGestureLeft];
    
    CGRect frame = [self frameShowed];
    
    [UIView animateWithDuration:0.1f animations:^{
        self.overlay.alpha = 1.f;
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
         self.view.frame = frame;
    }completion:^(BOOL finished){
        id delegate = self.delegate;
         if (delegate && [delegate respondsToSelector:@selector(sideMenuDidShow:)])
             [delegate sideMenuDidShow:self];
    }];
}

-(void)hide:(void (^)(void))complete
{
    [UIView animateWithDuration:0.3f animations:^{
         self.view.frame = [self frameHidden];
         self.overlay.alpha = 0.;
     }
                     completion:^(BOOL finished)
     {
         id delegate = self.delegate;
         if (delegate && [delegate respondsToSelector:@selector(sideMenuDidHide:)])
             [delegate sideMenuDidHide:self];
         PERFORM_BLOCK_IF_NOT_NIL(complete);
         [self.view removeFromSuperview];
         [self.overlay removeFromSuperview];
         [self.overlay removeGestureRecognizer:self->tapGesture];
         
         self.overlay = nil;
         self.tableView = nil;
         self.view = nil;
     }];
}

-(void)didTap:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self hide:nil];
}

-(CGRect)frameHidden
{
    CGFloat x = self.direction == VKSideMenuDirectionLeftToRight ? -self.width : [UIScreen mainScreen].bounds.size.width + self.width;
    return CGRectMake(x, 0, self.width, [UIScreen mainScreen].bounds.size.height);
}

-(CGRect)frameShowed
{
    CGFloat x = self.direction == VKSideMenuDirectionLeftToRight ? 0 : [UIScreen mainScreen].bounds.size.width - self.width;
    return CGRectMake(x, 0, self.width, self.view.frame.size.height);
}

@end
