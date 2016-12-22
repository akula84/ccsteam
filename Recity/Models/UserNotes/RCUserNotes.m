//
//  RCUserNotes.m
//  
//
//  Created by ezaji.dm on 15.07.16.
//
//

#import "RCUserNotes.h"
#import "RCProject.h"

@implementation RCUserNotes

+ (instancetype)itemWithProject:(RCProject *)project
                      inContext:(NSManagedObjectContext *)context {
    RCUserNotes *item = [RCUserNotes MR_createEntityInContext:context];
    item.projectUID = project.uid;
    return item;
}

+ (RCUserNotes *)userNotesForProject:(RCProject *)project {
    return [RCUserNotes MR_findFirstByAttribute:@"projectUID"
                                      withValue:project.uid];;
}

- (NSDictionary *)dictionary{
    return @{kProjectId : self.projectUID,
             @"text" : self.textNotes};
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"_______________________\n"];
    
    [string appendFormat:@"          projectUID = %@\n", self.projectUID];
    [string appendFormat:@"          textNotes = %@\n", self.textNotes];
    [string appendFormat:@"          lastModifiedAt = %@\n", self.lastModifiedAt];
    [string appendFormat:@"          uid = %@\n",self.uid];
    
    return [string copy];
}

@end
