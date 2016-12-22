//
//  RCForecastPageController.h
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCItemProtocol.h"

@class RCAddress;

@interface RCAddressPageController : UIPageViewController <RCItemProtocol>

@property (strong, nonatomic) RCAddress *address;

- (void)scrollToTop;
- (void)scrollToMetrics;

- (BOOL)canFullScreen;
- (BOOL)canHalfScreen;

@end
