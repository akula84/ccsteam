//
//  RCConstants.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

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
#define RGB(R,G,B)    [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:A]
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

FOUNDATION_EXPORT CGFloat const kKeyBoardAnimation,
kCellInsets;

FOUNDATION_EXPORT NSString *const kPlanned,
*const kUnderConstruction,
*const kCompleted,
*const kUnannounced,
*const kStatus,
*const kUid,
*const kId,
*const kUpcomingtenants,
*const kNearbyDevelopments,
*const kTypeDetails,
*const kApartments,
*const kCondominiums,
*const kResidentialTbd,
*const kOffice,
*const kRetail,
*const kHotel,
*const kEntertainment,
*const kOther,
*const kTBD,
*const kCompletionDate,
*const kFloorCount,

//Suggestion
*const kProjectId,
*const kSuggestionType,
*const kStatusSuggestion,
*const kTenantsSuggestion,
*const kTextOtherSuggestion,

//Suggestion
*const kProjectId,
*const kSuggestionType,
*const kStatusSuggestion,
*const kTenantsSuggestion,
*const kTextOtherSuggestion,

// API
*const kLogin,
*const kPassword,
*const kGrant_type,

*const kContactUsMessage,
*const kContactUsReason,

*const kLatitude,
*const kLongitude,

// API URLs
*const kAPIBaseURL,
*const kAPIGetProjects,
*const kAPIGetProjectsDeletedids,
*const kAPIPostSignIn,
*const kAPIGetCities,
*const kAPIGetUserData,
*const kAPIGetGeoCoordinateChangeScore,
*const kAPISearch,
*const kAddFavorite,
*const kAPIRemoveFavorite,
*const kAPIProfile,
*const kAPIAddress,
*const kAPIPostSuggestion,
*const kAPIAddUserNotes,
*const kAPIContactUs,
*const kAPIShareCoordinateUrl,

//Notifications
*const kNotificationProjectsLoaded,
*const kNotificationMetricsCellNeedReload,
*const kNotificationCurrentDevelopmentIndexUpdated
;

//Numbers
FOUNDATION_EXPORT NSUInteger const kZoomLevelMaxForProjectOverlays
;
