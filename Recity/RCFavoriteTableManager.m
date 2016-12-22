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

@interface RCFavoriteTableManager ()

@property (strong, nonatomic) NSSet *unfavoritedProjectUIDs;

@end

@implementation RCFavoriteTableManager

- (void)projectFavoriteChanged:(NSNotification *)notification {
    RCProject *project = notification.object;
    
    BOOL isProjectFavorited = [[AppState sharedInstance].user isProjectFavoritedLocally:project];
    if (isProjectFavorited) {
        NSLog(@"NEW FAVORITED ITEM %@",project.uid);

        NSMutableSet *updatedUnfavoritedProjectUIDs = [self.unfavoritedProjectUIDs mutableCopy];
        [updatedUnfavoritedProjectUIDs removeObject:project.uid];
        self.unfavoritedProjectUIDs = updatedUnfavoritedProjectUIDs;

        NSInteger index = [[self.items valueForKey:@"uid"] indexOfObject:project.uid];
        if (index != NSNotFound) {
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        } else {
            [self.tableView beginUpdates];
            self.items = [self.items arrayByAddingObject:project];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.items indexOfObject:project] inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }
    } else {
        NSInteger index = [[self.items valueForKey:@"uid"] indexOfObject:project.uid];
        if (index != NSNotFound) {
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        
        if (!self.unfavoritedProjectUIDs) {
            self.unfavoritedProjectUIDs = [NSSet set];
        }
        self.unfavoritedProjectUIDs = [self.unfavoritedProjectUIDs setByAddingObject:project.uid];
    }
    RUN_BLOCK(self.didFavoritedProjectsListChangedBlock);
}

- (void)removeUnfavoritedProjects {
    NSLog(@"uids for remove %@",self.unfavoritedProjectUIDs);
    if (self.unfavoritedProjectUIDs.count > 0) {
        __unused NSMutableArray *itemsForRemove = [@[] mutableCopy];
        NSMutableArray *indexpathsForRemove = [@[] mutableCopy];
        NSIndexSet *indexesForRemove = [self.items indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RCProject *project = (RCProject *)obj;
            BOOL result = [self.unfavoritedProjectUIDs containsObject:project.uid];
            if (result) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexpathsForRemove addObject:indexPath];
            }
            return result;
        }];
        
        NSLog(@"ITEMS FOR REMOVE %@",[itemsForRemove valueForKey:@"uid"]);
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
    RCProject *project = (RCProject *)item;
    cell.project = project;
}

@end
