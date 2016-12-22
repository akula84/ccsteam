//
//  RCWeaterViewController+Tap.m
//  Ccsteam
//
//  Created by Artem Kulagin on 22.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCWeaterViewController_Private.h"

@implementation RCWeaterViewController (Tap)

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)actionTap
{
    [self hideKeyBoard];
}

@end
