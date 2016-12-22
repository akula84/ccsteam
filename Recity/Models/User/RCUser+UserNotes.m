//
//  RCUser+UserNotes.m
//  Recity
//
//  Created by ezaji.dm on 21.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUser.h"
#import "RCProject.h"
#import "RCUserNotes.h"
#import "RCUserInfo.h"
#import "RCAddUserNotesAPI.h"

NSString *const RCUserNotesDidUpdateNotification = @"RCUserNotesDidUpdateNotification";

@implementation RCUser (UserNotes)

- (void)setNotesWithText:(NSString *)text
              forProject:(RCProject *)project
{
    if(text.length == 0) return;
    
    RCUserNotes *userNote = [RCUserNotes userNotesForProject:project];
    if(!userNote)
    {
        NSManagedObjectContext *managedObjectContext = [self.userinfo managedObjectContext];
        userNote = [RCUserNotes itemWithProject:project
                                      inContext:managedObjectContext];
        [self.userinfo addUserNotesObject:userNote];
    }
    
    userNote.textNotes = text;
    [RCAddUserNotesAPI withObject:[userNote dictionary]
                       completion:^(id reply, NSError *error, BOOL *handleError)
    {
        if(error) {
            [self.userinfo.managedObjectContext rollback];
        } else {
            NSDate *lastModifiedAt = [NSDate dateFromString:reply[@"lastModifiedAt"] withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            userNote.lastModifiedAt = lastModifiedAt;
            [self saveContext];
        }
    }];
}

- (void)deleteNotes:(RCUserNotes *)userNotes
{
    RCUser *user = [AppState sharedInstance].user;
    
    [user.userinfo removeUserNotesObject:userNotes];
    [userNotes MR_deleteEntity];
    [RCAddUserNotesAPI withObject:@{kProjectId : userNotes.projectUID,
                                    @"text" : @""}
                       completion:^(id reply, NSError *error, BOOL *handleError)
     {
         if(error) {
             [self.userinfo.managedObjectContext rollback];
         } else {
             [self saveContext];
         }
     }];
}

- (void)saveContext
{
    [[self.userinfo managedObjectContext] MR_saveOnlySelfWithCompletion:^(BOOL contextDidSave, NSError * __MR_nullable errorCD)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RCUserNotesDidUpdateNotification
                                                            object:nil];
    }];
}

@end
