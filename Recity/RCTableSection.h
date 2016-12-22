//
//  RCTableSection.h
//  Recity
//
//  Created by Matveev on 27/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTableSection : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *items;

@end
