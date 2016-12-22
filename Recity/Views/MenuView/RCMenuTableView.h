//
//  RCMenuTableView.h
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//
#import "BaseViewWithXIBInit.h"

@interface RCMenuTableView : BaseViewWithXIBInit

@property (copy, nonatomic) void (^didSelect)(NSIndexPath *indexPath);

- (void)prepareItems:(NSArray *)items;

@end
