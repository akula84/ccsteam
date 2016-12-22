//
//  NSObject+Utils.h
//  Test
//
//  Created by El-Machine on 5/2/12.
//  Copyright (c) 2012 Cookie. All rights reserved.
//

#import <UIKit/UIKit.h>


#define mSetVariableInRange(variable, min, max) if (variable<min){variable=min;}else{if (variable>max){variable=max;}}

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_sync(block)\
dispatch_sync(dispatch_get_main_queue(), block);

#define dispatch_main_async(block)\
dispatch_async(dispatch_get_main_queue(), block);

#define NSLocalizedKey(key)                         NSLocalizedString(key, nil)

#define mFEqual(a,b)                                (fabsf((a) - (b)) < FLT_EPSILON)
#define mFEqualzero(a)                              (fabsf(a) < FLT_EPSILON)
#define mFabsLess(a,b)                              (fabsf(a)<fabs(b))
#define mFabsMore(a,b)                              (fabsf(a)>fabs(b))

#define mEqual(a,b)                                 (fabs((a) - (b)) < DBL_EPSILON)
#define mEqualzero(a)                               (fabs(a) < DBL_EPSILON)
#define mAbsLess(a,b)                               (fabs(a)<fabs(b))
#define mAbsMore(a,b)                               (fabs(a)>fabs(b))

#define NSAssertShouldOverride                      _Pragma("clang diagnostic push") \
                                                    _Pragma("clang diagnostic ignored \"-Wreturn-type\"") \
                                                    { \
                                                        NSAssert(NO, @"Subclasses should override this method"); \
                                                    } \
                                                    _Pragma("clang diagnostic pop")

#define NSAssertUnhandledValue(value)               NSAssert(NO, @"Unhandled value: %@", value)
#define NSAssertUndefinedValue(propertyName, value) NSAssert(NO, @"%@ should be defined, unhandled value: %@",\
                                                    propertyName, value)

#define NS_AVOID_DIRECT_USE                         __attribute__((deprecated("Avoid direct use")))

#define NS_SUPPRESS_DIRECT_USE(expr)                _Pragma("clang diagnostic push") \
                                                    _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")\
                                                    expr\
                                                    _Pragma("clang diagnostic pop")

#define NS_ENUM_NOT_AVAILABLE(message, use)         __attribute__((deprecated(message))) = use
#define PROPERTY_NOT_IMPLEMENTED                    __attribute__((deprecated("property not implemented")))

#define mColorFromRGBA(r, g, b, a)                  [UIColor colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a]
#define mColorFromRGB(r, g, b)                      mColorFromRGBA(r, g, b, 1.0)

#define mColorFromRGBA_255(r, g, b, a)              [UIColor colorWithRed:(CGFloat)r/255 \
                                                                    green:(CGFloat)g/255 \
                                                                     blue:(CGFloat)b/255 \
                                                                    alpha:(CGFloat)a/100]
#define mColorFromRGB_255(r, g, b)                  mColorFromRGBA_255(r, g, b, 255.0)
#define mColorFromRGB_255_single(c)                 mColorFromRGB_255(c, c, c)

#define GCD_AFTER(seconds, block) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);

#define GCD_ONCE(block)\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, block);

#define CLLocationCoordinate2DEqual(c1, c2)             mEqual(c1.latitude, c2.latitude) && \
                                                        mEqual(c1.longitude, c2.longitude)

#define isIPadPro ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && ([UIScreen mainScreen].bounds.size.height == 1366 || [UIScreen mainScreen].bounds.size.width == 1366))



@interface NSObject (Utils)

/**
 *  Returns object created from xib with same name as class
 *
 *  @return New object
 */
+ (id)objectFromXib;

/**
 *  Returns object created from xib with same name as class
 *
 *  @param owner Owner of object's relations
 *
 *  @return New object
 */
+ (id)objectFromXibWithOwner:(id)owner;

/**
 *  Returns main apps window
 */
- (UIWindow *)mainWindow;

/**
 *  Returns root apps view controller
 */
- (UIViewController *)rootViewController;

@end
