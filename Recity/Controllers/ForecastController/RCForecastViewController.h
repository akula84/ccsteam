//
//  RCForecastViewController.h
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTableViewController.h"

#import "RCItemProtocol.h"

@class RCAddress;

@interface RCForecastViewController : RCBaseTableViewController <RCItemProtocol>

@property (strong, nonatomic) RCAddress *address;

@end