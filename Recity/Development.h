//
//  Development.h
//  Recity
//
//  Created by Matveev on 15/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Development : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *comment;
@property (assign, nonatomic) BOOL favorited;

@end
