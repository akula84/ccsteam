//
//  RCProjectDetailsViewController+UserNotes.m
//  Recity
//
//  Created by ezaji.dm on 15.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController_Private.h"
#import "RCUserNotesCell.h"

#import "RCUserNotesViewController.h"

#import "RCUserInfo.h"

@implementation RCProjectDetailsViewController (UserNotes)

- (void)prepareUserNotesHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserNotesCell:)
                                                 name:RCUserNotesCellDidChangeStateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userNotesDidUpdate)
                                                 name:RCUserNotesDidUpdateNotification
                                               object:nil];
}

- (void)cleanUserNotesHandler
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userNotesDidUpdate {
    [self.tableManager reloadData];
}

- (void)updateUserNotesCell:(NSNotification *)notification {
    RCUserNotesCell *userNotesCell = notification.object;
    if([self.tableManager.tableView.visibleCells containsObject:userNotesCell]) {
        [userNotesCell.contentView layoutIfNeeded];
        [self.tableManager.tableView beginUpdates];
        [self.tableManager.tableView endUpdates];
    }
}

- (RCUserNotesCell *)userNotesCellWithSubview:(UIView *)subview {
    if(!subview) return nil;
    
    if([subview isKindOfClass:[RCUserNotesCell class]]) {
        return (RCUserNotesCell *)subview;
    }
    
    return [self userNotesCellWithSubview:subview.superview];
}

- (IBAction)editAction {
    RCUserNotesViewController *userNotesVC = [[RCUserNotesViewController alloc] initWithNibName:[RCUserNotesViewController rc_className]
                                                                                         bundle:nil];
    userNotesVC.project = self.project;
    [self.navigationController pushViewController:userNotesVC
                                         animated:NO];
}

@end
