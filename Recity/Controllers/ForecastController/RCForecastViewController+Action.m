//
//  RCForecastViewController+Action.m
//  Recity
//
//  Created by Artem Kulagin on 06.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastViewController_Private.h"

#import "RCFloatViewSliderController.h"
#import "RCMapController.h"
#import "RCInfoView.h"

@implementation RCForecastViewController (Action)

- (IBAction)actionBack:(id)sender
{
    [self backCell];
}

- (IBAction)actionNext:(id)sender
{
    [self nextCell];
}

- (IBAction)questionAction:(id)sender
{
    RCInfoView *info = [RCInfoView loadNib];
    [info setupHeaderText:@"About Development Forecast"
                 mainText:@"The Development Forecast displays all nearby projects in a timeline view based on expected completion."
             okButtonText:@"Got it"];
    [info displayOnView:self.navigationController.view];
}

- (IBAction)displayFullscreen
{
    [RCFloatViewSliderController displayFullscreen];
}

- (IBAction)actionSeeMore:(id)sender
{
    [RCMapController showItem:[self currentProject]];
}

@end
