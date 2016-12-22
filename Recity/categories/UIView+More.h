/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (More)

+ (CGFloat)heightForDesireWidth:(CGFloat)desireWidth withAspectRatioWidth:(CGFloat)width toHeight:(CGFloat)height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

+ (instancetype) loadFromNib;
+ (instancetype) loadFromNib:(NSString *) nibName;
+ (instancetype) loadFromNib:(NSString *) nibName withOwner:(id) owner;

- (CGFloat)fittingHeight;

- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
- (void)setShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity;

- (BOOL)hasFirstResponder;
- (UIView *)findViewThatIsFirstResponder;

- (CGPoint)viewOriginAtScreenCoordinates;
- (CGPoint)viewOriginAtViewCoordinates:(UIView *)view;
- (CGRect)viewFrameAtScreenCoordinates;
- (CGRect)viewFrameAtViewCoordinates:(UIView *)view;


+ (CGPoint)pointAtScreenCoordinates:(CGPoint)point usedAtView:(UIView *)view;

@end
