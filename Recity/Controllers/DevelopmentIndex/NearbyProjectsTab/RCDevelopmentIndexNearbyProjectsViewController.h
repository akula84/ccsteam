//
//  RCDevelopmentIndexNearbyProjectsViewController.h
//  Recity
//
//  Created by Vitaliy Zhukov on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTableViewController.h"

#import "RCItemProtocol.h"

@class RCAddress;

@interface RCDevelopmentIndexNearbyProjectsViewController : RCBaseTableViewController <RCItemProtocol>

@property (strong, nonatomic) RCAddress *address;

@end
