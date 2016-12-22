//
//  RCSearchRecentViewDelegate.h
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCSearchManager;

@protocol RCSearchManagerDelegate<NSObject>

- (void)searchManager:(RCSearchManager *)searchManager didRecentText:(NSString *)text;
- (void)searchManager:(RCSearchManager *)searchManager showItem:(id)item;

@end
