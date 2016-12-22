//
//  RCDevelopmentIndexViewController.h
//  Recity
//
//  Created by Vitaliy Zhukov on 20.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTableViewController.h"
#import "RCItemProtocol.h"

@class RCAddress;

@interface RCDevelopmentIndexViewController : RCBaseViewController <RCItemProtocol>

@property (strong, nonatomic) RCAddress *address;

- (void)scrollToMetrics;

@end
