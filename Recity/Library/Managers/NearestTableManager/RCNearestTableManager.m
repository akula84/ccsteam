//
//  RCNearestTableManager.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNearestTableManager.h"
#import "RCDevelopmentCell.h"
#import "RCProject.h"

@implementation RCNearestTableManager

- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    return [RCDevelopmentCell rc_className];
}

- (NSArray *)cellNibNames {
    return @[[RCDevelopmentCell rc_className]];
}

- (void)configureCell:(RCDevelopmentCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    cell.item = item;
     
    @weakify(self);
    cell.didPressedProjectImageBlock = ^(RCProject *blockProject) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock,blockProject);
    };
}

@end
