//
//  RCAddUserNotesAPI.m
//  Recity
//
//  Created by ezaji.dm on 15.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddUserNotesAPI.h"

#import "API_Protected.h"

@implementation RCAddUserNotesAPI

- (NSString *)path {
    return kAPIAddUserNotes;
}

- (NSMutableDictionary *)parameters {
    return self.object;
}

@end
