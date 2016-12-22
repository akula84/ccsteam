//
//  VKSideMenu+Views.h
//  Recity
//
//  Created by Artem Kulagin on 06.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "VKSideMenu.h"

@class RCLeftMenu;

@interface VKSideMenu()

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) NSArray *items;

-(void)hide:(void (^)(void))complete;

@end

@interface VKSideMenu (Views)

- (void)prepareViews;

@end
