//
//  RCConstants.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kProjectFavoriteChangedNotification @"kProjectFavoriteChangedNotification"

#define kDarkPurpleColor            RGB(47,53,144)
#define kLightedDarkPurpleColor     RGB(130,131,190)
#define kDisabledButtonPurpleColor  RGB(200,200,250)

#define kCellPurpleColor            RGB(42,48,119)
#define kCellLightPurpleColor       RGB(122,122,172)

#define kMediumOrangeColor          RGB(244,142,41)
#define kSmallIconOrangeColor       RGB(232,134,52)

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...) {}
#endif

#define PERFORM_BLOCK_IF_NOT_NIL(block, ...) \
if (block) {\
block(__VA_ARGS__); \
}

#define PERFORM_BLOCK_IN_MAIN_THREAD_IF_NOT_NIL(block, ...) \
if (block) { \
if (![NSThread isMainThread]) { \
dispatch_async(dispatch_get_main_queue(), ^{ \
block(__VA_ARGS__); \
}); \
} else { \
block(__VA_ARGS__); \
}\
}

#define RUN_BLOCK(block, ...) if (block != nil) { block(__VA_ARGS__); }
#define RGB(R,G,B)    [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
#define IMG(name) [UIImage imageNamed:name]
#define LOC(key)    NSLocalizedString((key), @"")
#define ASSERT(condition) NSAssert(condition,@"CUSTOM ASSERT WARNING")
#define CUSTOM_ERROR(text) [[NSError alloc] initWithDomain:@"CustomDomain" code:5 userInfo:@{ NSLocalizedDescriptionKey : text}]
#define THROW_EXCEPTION(name, reason) [NSException exceptionWithName:name reason:reason userInfo:nil]

typedef void (^EmptyBlock)();
typedef void (^ObjectITErrorCompletionBlock)(id object, NSError *error);
typedef void (^CompletionBlock)(id object, NSError *error);
typedef void (^ProgressBlock)(NSProgress *);
typedef void (^RCDataSuccessBlock)(NSArray *objects);
typedef void (^RCDataFailureBlock)(NSError *error);

