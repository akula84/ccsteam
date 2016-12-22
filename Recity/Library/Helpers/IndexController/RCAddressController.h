//
//  RCIndexController.h
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

@class RCAddress, RCToolbarItemCell;

@interface RCAddressController : NSObject

@property (copy, nonatomic) void(^didSelectIndexPath)(NSIndexPath *indexPath,BOOL animated);
@property (copy, nonatomic) void(^didToolbarItemCellUpdatedBlock)(RCToolbarItemCell *toolbarItemCell,NSIndexPath *indexPath);

@property (strong, nonatomic) RCAddress *currentAddress;

+ (void)prepareToolbarFromStateIndex:(NSInteger)toolbarViewItemIndex;
+ (void)selectIndexPath:(NSIndexPath *)indexPath;
+ (void)selectIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
+ (void)selectForecast;

+ (void)toolbarItemCellUpdatedBlock:(RCToolbarItemCell *)toolbarItemCell indexPath:(NSIndexPath *)indexPath;

@end
