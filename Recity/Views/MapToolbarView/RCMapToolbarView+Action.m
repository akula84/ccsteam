//
//  RCMapToolbarView+Action.m
//  Recity
//
//  Created by Artem Kulagin on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapToolbarView_Private.h"

#import "RCFloatViewSliderController.h"
#import "RCDetailController.h"
#import "RCAddressController.h"

@implementation RCMapToolbarView (Action)

- (void)didToolbarViewItemSelected:(NSInteger)toolbarViewItemIndex selectedItemPressed:(BOOL)selectedItemPressed
{
    switch (self.state) {
        case RCMapToolbarViewStateNormal:
            [RCFloatViewSliderController prepareToolbarFromStateNormal:toolbarViewItemIndex selectedItemPressed:selectedItemPressed];
            break;
        case RCMapToolbarViewStateDetails:
            [RCDetailController prepareToolbarFromStateDetails:toolbarViewItemIndex];
            break;
        case RCMapToolbarViewStateIndex:{
            [RCAddressController prepareToolbarFromStateIndex:toolbarViewItemIndex];
        }
            break;
        default:
            break;
    }
}

@end
