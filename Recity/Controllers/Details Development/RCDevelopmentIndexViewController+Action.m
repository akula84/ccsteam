//
//  RCDevelopmentIndexViewController+Action.m
//  Recity
//
//  Created by Artem Kulagin on 07.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexViewController_Private.h"

#import "FavoriteHelper.h"
#import "RCInfoView.h"
#import "RCFloatViewSliderController.h"

@implementation RCDevelopmentIndexViewController (Action)

- (IBAction)favoriteButtonAction:(UIButton *)sender
{
    [FavoriteHelper favoriteAction:self.address favoriteButton:sender];
}

- (IBAction)showInfoAction:(id)sender
{
    RCInfoView *info = [RCInfoView loadNib];
    [info displayOnView:self.navigationController.view];
}

- (IBAction)displayFullscreen
{
    if ([AppState advancedVersion]) {
        [RCFloatViewSliderController displayFullscreen];
    }
}

- (IBAction)switchToForecastAction
{
    if(![RCFloatViewSliderController isScrollViewMoved]) {
        [RCAddressController selectForecast];
        [RCFloatViewSliderController displayFullscreen];
    }
}

@end
