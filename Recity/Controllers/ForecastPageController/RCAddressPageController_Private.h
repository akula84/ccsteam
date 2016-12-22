//
//  RCIndexPageController+Delegate.h
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddressPageController.h"

@interface RCAddressPageController()

@property (strong, nonatomic) NSArray *items;

@end

@interface RCAddressPageController (Delegate)<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end
