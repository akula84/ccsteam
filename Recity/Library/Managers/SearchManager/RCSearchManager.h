//
//  SearchManager.h
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

#import "RCSearchManagerDelegate.h"
#import <CoreLocation/CLLocation.h>

@interface RCSearchManager : NSObject

@property (weak, nonatomic) id<RCSearchManagerDelegate> delegate;
@property (strong, nonatomic) NSString *searchText;
@property (assign, nonatomic) BOOL searchInProgress;
@property (assign, nonatomic) BOOL showResultAddressInMap;

+ (void)resultClear;
+ (id)resultItem;
- (void)prepareSearchText:(NSString *)text centerCoordinate:(CLLocationCoordinate2D)centerCoordinate;

@end

@interface RCSearchManager (Recent)

typedef void (^complete) (NSArray *array);
- (void)recents:(complete)complete;
- (void)addRecent:(NSString *)text;

@end

@interface RCSearchManager (Delegate)

- (void)didRecentText:(NSString *)text;
- (void)didResultItem:(id)item;

@end

@interface RCSearchManager (Result)

- (void)result:(complete)complete;

@end
