//
//  RCToolbarController.h
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"
#import "RCToolbarItemCell.h"

typedef NS_ENUM(NSInteger, RCMapToolbarViewState) {
    RCMapToolbarViewStateNormal = 0,
    RCMapToolbarViewStateDetails = 1,
    RCMapToolbarViewStateIndex = 2
};

@interface RCToolbarController : NSObject

@property (copy, nonatomic) void(^didSelectIndexPath)(NSIndexPath *indexPath);
@property (copy, nonatomic) void(^didSelectPreviousItem)();
@property (copy, nonatomic) void(^didSelectIndexPathIfNormal)(NSIndexPath *indexPath);
@property (copy, nonatomic) void(^didSwitchToolbarToState)(RCMapToolbarViewState state);
@property (copy, nonatomic) void(^didResetSelectionAnimated)(BOOL animated);
@property (copy, nonatomic) void(^didEraseUnfavoritedProjects)(dispatch_block_t completion);
@property (copy, nonatomic) RCToolbarItemCell *(^toolbarItemCellForIndexPathBlock)(NSIndexPath *indexPath);

@property (copy, nonatomic) RCMapToolbarViewState (^toolbarState)();

@property (copy, nonatomic) NSIndexPath *(^currentIndexPathSelectedItem)();

@property (copy, nonatomic) void(^reloadToolbar)();

@property (strong, nonatomic, readonly) NSNumber *currentDevelopmentIndex;
@property (assign, nonatomic, readonly) BOOL disabledLoadAddressMode;

+ (void)selectIndexPath:(NSIndexPath *)indexPath;
+ (void)selectPreviousItem;
+ (void)selectIndexPathIfNormal:(NSIndexPath *)indexPath;
+ (void)switchToolbarToState:(RCMapToolbarViewState)state;
+ (void)resetSelectionAnimated:(BOOL)animated;
+ (void)eraseUnfavoritedProjectsAtFavoritesTabIfIsNotFavoritesTabSelectedNow:(dispatch_block_t)completion;

+ (RCToolbarItemCell *)toolbarItemCellForIndexPath:(NSIndexPath *)indexPath;
+ (void)setDisabledLoadAddressMode:(BOOL)disabled;
+ (void)setIndexForDevelopmentIndexCell:(NSNumber *)index;

@end
