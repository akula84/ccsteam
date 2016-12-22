//
//  RCMyLocationButton.m
//  Recity
//
//  Created by Artem Kulagin on 01.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMyLocationButton.h"

#import "MyLocationButtonController.h"
#import "RCMapController.h"

@implementation RCMyLocationButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareController];
        [self addTarget:self action:@selector(showMyself:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)prepareController
{
    @weakify(self);
    [MyLocationButtonController shared].prepareActived = ^(BOOL actived){
        @strongify(self);
        [self prepareActived:actived];
    };
}

- (void)showMyself:(id)sender
{
    [RCMapController showMyLocation];
}

- (void)prepareActived:(BOOL)actived
{
    NSString *name = actived?@"my_locationOrange":@"my_location";
    [self setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

@end
