//
//  RCRecentTableManager.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCRecentTableManager.h"
#import "RCMarkeredDevelopmentCell.h"
#import "RCProject.h"

@implementation RCRecentTableManager

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    return [RCMarkeredDevelopmentCell rc_className];
}

- (NSArray *)cellNibNames {
    return @[[RCMarkeredDevelopmentCell rc_className]];
}

- (void)configureCell:(RCMarkeredDevelopmentCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    cell.item = item;
}

@end
