//
//  SearchManager+Stub.h
//  Recity
//
//  Created by Artem Kulagin on 01.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchManager.h"

@class RCSearchAPI;

@interface RCSearchManager ()

@property (assign, nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (strong, nonatomic) id resultItem;
@property (strong, nonatomic) RCSearchAPI *api;

@end

@interface RCSearchManager()

- (void)saveContext;

@end

