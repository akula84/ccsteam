//
//  RCFilterDateSelector.h
//  Recity
//
//  Created by Vitaliy Zhukov on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface RCFilterDateSelector : UITableViewController

@property (strong, nonatomic) NSArray <NSNumber *> *values;
@property (strong, nonatomic) void(^completionBlock)(NSNumber *selected);

@end
