//
//  RCDetailController.h
//  Recity
//
//  Created by Artem Kulagin on 13.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//
#import "NSObject+SingletonObject.h"

#import "RCDetailsSection.h"

@class RCToolbarItemCell;

@interface RCDetailController : NSObject

@property (copy, nonatomic) void(^didScrollToProjectDetailsSection)();
@property (copy, nonatomic) void(^didPrepareToolbarFromStateDetails)(NSInteger toolbarViewItemIndex);
@property (copy, nonatomic) void(^didToolbarItemCellUpdatedBlock)(RCToolbarItemCell *toolbarItemCell,NSIndexPath *indexPath);
@property (assign, nonatomic) DetailsSectionType selectedSectionType;

+ (void)scrollToProjectDetailsSection;
+ (void)prepareToolbarFromStateDetails:(NSInteger)toolbarViewItemIndex;
+ (void)toolbarItemCellUpdatedBlock:(RCToolbarItemCell *)toolbarItemCell indexPath:(NSIndexPath *)indexPath;

+ (void)selectSectionWithType:(DetailsSectionType)sectionType;
+ (void)resetSelectionSection;

@end
