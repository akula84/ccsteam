//
//  RCFavoriteTableManager.m
//  Recity
//
//  Created by Matveev on 22/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCFavoriteTableManager.h"

#import "RCMarkeredDevelopmentCell.h"
#import "RCProject.h"
#import "RCAddress.h"

@interface RCFavoriteTableManager ()

@property (strong, nonatomic) NSSet *unfavoritedProjectUIDs;

@end

@implementation RCFavoriteTableManager

- (void)projectFavoriteChanged:(NSNotification *)notification {
    id item = notification.object;
    NSString *key;
    id object;
    if ([item isKindOfClass:[RCProject class]]) {
        key = kUid;
        object = ((RCProject *)item).uid;
    } else if ([item isKindOfClass:[RCAddress class]]){
        key = @"address";
        object = ((RCAddress *)item).address;
    }
    BOOL isProjectFavorited = [[AppState sharedInstance].user isItemFavoritedLocally:item];
    if (isProjectFavorited) {
        [self addItem:item key:key object:object];
    } else {
        [self removeItem:item key:key object:object];
    }
    RUN_BLOCK(self.didFavoritedProjectsListChangedBlock);
}

- (void)addItem:(id)item key:(NSString *)key object:(id)object
{
    
    NSMutableSet *updatedUnfavoritedProjectUIDs = [self.unfavoritedProjectUIDs mutableCopy];
    [updatedUnfavoritedProjectUIDs removeObject:object];
    self.unfavoritedProjectUIDs = updatedUnfavoritedProjectUIDs;
    NSUInteger index = [[self.items valueForKey:key] indexOfObject:object];
    
    if (index != NSNotFound) {
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        self.items = [self.items arrayByAddingObject:item];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)[self.items indexOfObject:item] inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newFavorite" object:nil];
}

-(void)removeItem:(id)item key:(NSString *)key object:(id)object
{
    NSUInteger index = [[self.items valueForKey:key] indexOfObject:object];
    if (index != NSNotFound) {
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)index inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    
    if (!self.unfavoritedProjectUIDs) {
        self.unfavoritedProjectUIDs = [NSSet set];
    }
    self.unfavoritedProjectUIDs = [self.unfavoritedProjectUIDs setByAddingObject:object];
}

- (void)removeUnfavoritedProjects {
     if (self.unfavoritedProjectUIDs.count > 0) {
        __unused NSMutableArray *itemsForRemove = [@[] mutableCopy];
        NSMutableArray *indexpathsForRemove = [@[] mutableCopy];
        NSIndexSet *indexesForRemove = [self.items indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id key = @"";
            if ([obj isKindOfClass:[RCProject class]]) {
                 key = ((RCProject *)obj).uid;
            }else if ([obj isKindOfClass:[RCAddress class]]) {
                 key = ((RCAddress *)obj).address;
            }
            BOOL result = [self.unfavoritedProjectUIDs containsObject:key];
            
            if (result) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)idx inSection:0];
                [indexpathsForRemove addObject:indexPath];
            }
            return result;
        }];
        
        if (indexpathsForRemove.count > 0) {
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexpathsForRemove withRowAnimation:UITableViewRowAnimationAutomatic];
            NSMutableArray *remainedItems = [self.items mutableCopy];
            [remainedItems removeObjectsAtIndexes:indexesForRemove];
            self.items = remainedItems;
            [self.tableView endUpdates];
        }
        self.unfavoritedProjectUIDs = [NSSet set];
    }
}

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
