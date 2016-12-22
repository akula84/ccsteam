/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "UIView+More.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIView (More)

+ (CGFloat)heightForDesireWidth:(CGFloat)desireWidth withAspectRatioWidth:(CGFloat)width toHeight:(CGFloat)height {
    CGFloat result = desireWidth * height / width;
    return result;
}

- (CGPoint) origin
{
	return self.frame.origin;
}

- (CGSize) size
{
	return self.frame.size;
}

- (CGFloat) x
{
	return self.frame.origin.x;
}

- (CGFloat) y
{
	return self.frame.origin.y;
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (CGFloat) height
{
	return self.frame.size.height;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setOrigin:(CGPoint) newOrigin
{
	CGRect selfFrame = self.frame;
	
	selfFrame.origin = newOrigin;
	
	self.frame = selfFrame;
}

- (void) setSize:(CGSize) newSize
{
	CGRect selfFrame = self.frame;
	
	selfFrame.size = newSize;
	
	self.frame = selfFrame;
}

- (void) setX:(CGFloat) newX
{
	CGRect selfFrame = self.frame;
	
	selfFrame.origin.x = newX;
	
	self.frame = selfFrame;
}

- (void) setY:(CGFloat) newY
{
	CGRect selfFrame = self.frame;
	
	selfFrame.origin.y = newY;
	
	self.frame = selfFrame;
}

- (void) setWidth:(CGFloat) newWidth
{
	CGRect selfFrame = self.frame;
	
	selfFrame.size.width = newWidth;
	
	self.frame = selfFrame;
}

- (void) setHeight:(CGFloat) newHeight
{
	CGRect selfFrame = self.frame;
	
	selfFrame.size.height = newHeight;
	
	self.frame = selfFrame;
}

- (void) setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}

- (void) setRight:(CGFloat)right {
    self.x = right - self.width;
}

+ (instancetype) loadFromNib {
    return [self loadFromNib:[self rc_className]];
}

+ (instancetype) loadFromNib:(NSString *) nibName {
    return [self loadFromNib:nibName withOwner:nil];
}

+ (instancetype) loadFromNib:(NSString *) nibName withOwner:(id) owner {
    NSArray *loadedObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    for (id obj in loadedObjects) {
        Class classNamedAsNib = NSClassFromString(nibName);
        if ([obj isKindOfClass:classNamedAsNib]) {
            return obj;
        }
    }
    return nil;
}

- (CGFloat)fittingHeight {
    CGFloat result;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    result = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return result;
}

- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
    
    self.clipsToBounds = YES;
}

- (void)setShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = (float)shadowOpacity;
    
    self.clipsToBounds = NO;
}

- (BOOL)hasFirstResponder {
    BOOL result = [self findViewThatIsFirstResponder] != nil;
    return result;
}

- (UIView *)findViewThatIsFirstResponder
{
    UIView *result;
    if ([self isKindOfClass:[UITextField class]]) {
        NSLog(@"");
    }
    if ([self isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)self;
        if (textField.isEditing) {
            result = self;
        }
    } else if (self.isFirstResponder) {
        result = self;
    } else {
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self;
            [tableView.tableHeaderView findViewThatIsFirstResponder];
            [tableView.tableFooterView findViewThatIsFirstResponder];
        }
        for (UIView *subView in self.subviews) {
            UIView *firstResponder = [subView findViewThatIsFirstResponder];
            if (firstResponder != nil) {
                result = firstResponder;
                break;
            }
        }
    }
    
    return result;
}

- (CGPoint)viewOriginAtScreenCoordinates
{
    CGPoint resultPoint = [self.superview convertPoint:self.frame.origin toView:nil];
    return resultPoint;
}

- (CGPoint)viewOriginAtViewCoordinates:(UIView *)view
{
    CGPoint resultPoint = [self.superview convertPoint:self.frame.origin toView:view];
    return resultPoint;
}

- (CGRect)viewFrameAtScreenCoordinates
{
    CGRect resultFrame = [self.superview convertRect:self.frame toView:nil];
    return resultFrame;
}

- (CGRect)viewFrameAtViewCoordinates:(UIView *)view
{
    CGRect resultFrame = [self.superview convertRect:self.frame toView:view];
    return resultFrame;
}


+ (CGPoint)pointAtScreenCoordinates:(CGPoint)point usedAtView:(UIView *)view
{
    CGPoint resultPoint = [view convertPoint:point toView:nil];
    return resultPoint;
}

@end
