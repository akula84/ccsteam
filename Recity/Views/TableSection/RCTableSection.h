//
//  RCTableSection.h
//  Recity
//
//  Created by Matveev on 27/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface RCTableSection : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *items;

@property (assign, nonatomic) BOOL isShowHeader; //default is YES.

@end
