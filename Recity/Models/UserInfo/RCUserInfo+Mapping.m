//
//  RCUserInfo+Mapping.m
//  Recity
//
//  Created by Artem Kulagin on 10.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUserInfo.h"

#import "RCFavoritedProjectInfo.h"
#import "RCParseHelper.h"
#import "RCAddress.h"
#import "RCUserNotes.h"

@implementation RCUserInfo (Mapping)

- (void)parse:(id)data
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSArray *favorites = data[@"favorites"];
    
    NSMutableArray *favoritesArray = [NSMutableArray array];
    for (NSDictionary *dict in favorites) {
        RCFavoritedProjectInfo *obj = [RCParseHelper parseObject:dict aClass:[RCFavoritedProjectInfo class] inContext:managedObjectContext];
        [self parseLocationAddressDict:dict inContext:managedObjectContext];
        [favoritesArray addObject:obj];
    }
    
    NSArray *userNotes = data[@"notes"];
    NSMutableArray *userNotesArray = [NSMutableArray array];
    for(NSDictionary *dict in userNotes) {
        RCUserNotes *obj = [RCParseHelper parseObject:dict aClass:[RCUserNotes class] inContext:managedObjectContext];
        [userNotesArray addObject:obj];
    }
        
    self.favoritedProjectInfos = [NSOrderedSet orderedSetWithArray:favoritesArray];
    self.userNotes = [NSOrderedSet orderedSetWithArray:userNotesArray];
    self.user = [RCParseHelper copyObject:[AppState sharedInstance].user inContext:managedObjectContext];
}

- (void)parseLocationAddressDict:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
    NSDictionary *location = dict[@"location"];
    if (location.isFull) {
        [RCAddress itemWithDict:location inContext:context];
    }
 }

- (NSString *)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________ %@\n",self.user];
    
    [string appendFormat:@"favoritedProjectInfos"];
    for (RCFavoritedProjectInfo *obj in  self.favoritedProjectInfos) {
        [string appendFormat:@" %@\n",obj];
    }
    return string;
}

@end
