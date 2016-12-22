//
//  RCFavoritableTableManager.m
//  Recity
//
//  Created by Matveev on 25/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFavoritableTableManager.h"

#import "RCProject.h"
#import "RCAddress.h"

@implementation RCFavoritableTableManager

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUseSeparatorsZeroInset:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(projectFavoriteChanged:) name:kProjectFavoriteChangedNotification object:nil];
}

- (void)projectFavoriteChanged:(NSNotification *)notification
{
     id item = notification.object;
     NSMutableArray *indexpathsForReload = [@[] mutableCopy];
    [self.items indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BOOL result = NO;
  
        if ([obj isKindOfClass:[RCProject class]]) {
            RCProject *currentProject = (RCProject *)obj;
            result = (currentProject.uid.integerValue == ((RCProject *)item).uid.integerValue);
        }else if ([obj isKindOfClass:[RCAddress class]]) {
            RCAddress *locationAddress = (RCAddress *)obj;
            result = ([locationAddress.address isEqualToString:((RCAddress *)item).address]);
        }
        if (result) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)idx inSection:0];
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
