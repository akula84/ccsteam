//
//  Utils.h
//  Recity
//
//  Created by Matveev on 12/04/16.
//  Copyright © 2016 RC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCProject;

typedef void (^DidPressedProjectImageBlock)(RCProject *project);

@interface Utils : NSObject

#define dispatch_main_async(block)\
dispatch_async(dispatch_get_main_queue(), block);

#define IOS_VERSION_FIRST_NUMBER ([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] firstObject] integerValue])
#define IOS_VERSION_SECOND_NUMBER ([[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."].count > 1 ? [[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:1] integerValue] : 0)
#define IOS_VERSION_THIRD_NUMBER ([[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."].count > 2 ? [[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:2] integerValue] : 0)

#define IS_DEBUG_BUILD [Utils isDebugBuild]

+ (BOOL)isDebugBuild;

#define IS_PHONE_4 [Utils isIphone4]
#define IS_PHONE_5 [Utils isIphone5]
+ (BOOL)isIphone4;
+ (BOOL)isIphone5;

+ (CGFloat)mostThinLineWidth;
+ (UIImage *)image:(UIImage *)image maskedByColor:(UIColor *)color;
+ (UIImage *)coloredRectImageWithFrame:(CGRect)frame withColor:(UIColor *)color;
+ (UIImage *)circleImageWithRadius:(CGFloat)radius
                   backgroundColor:(UIColor *)backgroundColor
                             image:(UIImage *)image;
+ (UIImage *)circleImageWithRadius:(CGFloat)radius
                       borderWidth:(CGFloat)borderWidth
                       borderColor:(UIColor *)borderColor;
+ (UIImage *)circleImageWithRadius:(CGFloat)radius
                       borderWidth:(CGFloat)borderWidth
                       borderColor:(UIColor *)borderColor
                             image:(UIImage *)image;
+ (BOOL)floatNumber:(CGFloat)number1 isEqualToFloatNumber:(CGFloat)number2;

#define EQUAL(a,b) [Utils isEqualObject1:a toObject2:b]

+ (BOOL)isEqualObject1:(id)obj1 toObject2:(id)obj2;

#define RELAYOUT(view) [view setNeedsLayout];[view layoutIfNeeded];
#define THROW_MISSED_IMPLEMENTATION_EXCEPTION @throw [NSException exceptionWithName:[NSString stringWithFormat:@"class %@: bad implementation",[self rc_className]] reason:[NSString stringWithFormat:@"method %s not implemented",__PRETTY_FUNCTION__] userInfo:nil];
#define CORRECTED_BOOL(expression) (expression ? YES : NO)

+ (NSInteger)randomNumberAtRangeExcludingEndWithStartNumber:(NSInteger)startNum withEndNumber:(NSInteger)endNum;

@end
