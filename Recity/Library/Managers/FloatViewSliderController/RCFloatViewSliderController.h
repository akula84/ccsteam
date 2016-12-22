//
//  RCFloatViewSliderController.h
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

@interface RCFloatViewSliderController : NSObject

@property (copy, nonatomic) void(^didNoDetectTableView)(UITableView *tableView);
@property (copy, nonatomic) void(^didDisplayFullscreen)();
@property (copy, nonatomic) void(^didDisplayHalfscreen)();
@property (copy, nonatomic) void(^didDisplayFullscreenIfHalf)(dispatch_block_t complete);
@property (copy, nonatomic) void(^didDisplayHalfscreenIfFull)(dispatch_block_t complete);
@property (copy, nonatomic) void(^didPrepareToolbarFromStateNormal)(NSInteger toolbarViewItemIndex,BOOL selectedItemPressed);
@property (copy, nonatomic) void(^didUpdateNearbyProjectsIfNeed)();

@property (copy, nonatomic) void(^didHideMenuCompletion)(dispatch_block_t completion1, dispatch_block_t completion2);

@property (copy, nonatomic) BOOL(^isScrollViewMoved)();
@property (copy, nonatomic) BOOL(^isDisplayedFull)();

+ (void)setNoDetectTableView:(UITableView *)tableView;
+ (void)displayFullscreen;
+ (void)displayFullscreenIfHalf:(dispatch_block_t)complete;
+ (void)displayHalfscreen;
+ (void)displayHalfscreenIfFull:(dispatch_block_t)complete;
+ (void)prepareToolbarFromStateNormal:(NSInteger)toolbarViewItemIndex selectedItemPressed:(BOOL)selectedItemPressed;
+ (void)hideMenuCompletion:(dispatch_block_t)completion1 andDisplayProjectDetailsAnimatedCompletion:(dispatch_block_t)completion2;

+ (BOOL)isDisplayedFull;

+ (void)updateNearbyProjectsIfNeed;

+ (BOOL)isScrollViewMoved;

@end
