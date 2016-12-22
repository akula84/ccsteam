//
//  RCConstants.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

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
#define RGB(R,G,B)    [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:A]
#define IMG(name) [UIImage imageNamed:name]
#define LOC(key)    NSLocalizedString((key), @"")
#define ASSERT(condition) NSAssert(condition,@"CUSTOM ASSERT WARNING")
#define CUSTOM_ERROR(text) [[NSError alloc] initWithDomain:@"CustomDomain" code:5 userInfo:@{ NSLocalizedDescriptionKey : text}]
#define THROW_EXCEPTION(name, reason) [NSException exceptionWithName:name reason:reason userInfo:nil]

// API URLs
FOUNDATION_EXPORT NSString *const token,
*const kAPIBaseURL,
*const kWeather,
*const kImage;

