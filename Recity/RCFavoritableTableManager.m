//
//  RCFavoritableTableManager.m
//  Recity
//
//  Created by Matveev on 25/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFavoritableTableManager.h"
#import "RCProject.h"

@implementation RCFavoritableTableManager

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUseSeparatorsZeroInset:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectFavoriteChanged:) name:kProjectFavoriteChangedNotification object:nil];
}

- (void)projectFavoriteChanged:(NSNotification *)notification {
    RCProject *project = notification.object;
    
    NSMutableArray *indexpathsForReload = [@[] mutableCopy];
    [self.items indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RCProject *currentProject = (RCProject *)obj;
        BOOL result = (currentProject.uid.integerValue == project.uid.integerValue);
        if (result) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexpathsForReload addObject:indexPath];
        }
        return result;
    }];
    
    if (indexpathsForReload.count > 0) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexpathsForReload withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

@end
