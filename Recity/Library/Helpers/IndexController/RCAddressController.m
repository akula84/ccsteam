//
//  RCIndexController.m
//  Recity
//
//  Created by Artem Kulagin on 05.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCAddressController.h"

#import "RCToolbarController.h"
#import "RCFloatViewSliderController.h"

#import "RCMapController.h"
#import "SharePopupView.h"
#import "RCAddress.h"

@implementation RCAddressController
SINGLETON_OBJECT

+ (void)selectIndexPath:(NSIndexPath *)indexPath
{
    [self selectIndexPath:indexPath animated:NO];
}

+ (void)selectIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [RCToolbarController selectIndexPath:indexPath];
    RUN_BLOCK([self controller].didSelectIndexPath,indexPath,animated);
}

+ (RCAddressController *)controller
{
    return [RCAddressController shared];
}

+ (void)selectForecast
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self selectIndexPath:indexPath];
}


+ (void)floatViewSliderDisplayFullscreen:(dispatch_block_t)complete
{
    [RCFloatViewSliderController displayFullscreenIfHalf:complete];
}

+ (void)floatViewSliderDisplayHalfscreen:(dispatch_block_t)complete
{
    [RCFloatViewSliderController displayHalfscreenIfFull:complete];
}

+ (void)toolbarItemCellUpdatedBlock:(RCToolbarItemCell *)toolbarItemCell indexPath:(NSIndexPath *)indexPath
{
    RUN_BLOCK([self controller].didToolbarItemCellUpdatedBlock,toolbarItemCell,indexPath);
}

+ (void)prepareToolbarFromStateIndex:(NSInteger)toolbarViewItemIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:toolbarViewItemIndex inSection:0];
    switch (toolbarViewItemIndex) {
        case 0:{
            
            if ([AppState advancedVersion]) {
                [self floatViewSliderDisplayFullscreen:^{
                    [self selectIndexPath:indexPath];
                }];
            } else {
                [self floatViewSliderDisplayHalfscreen:^{
                    [self selectIndexPath:indexPath];
                }];
            }
        }
            break;
        case 1:{
            [self selectForecast];
            [self floatViewSliderDisplayFullscreen:^{
                
            }];
        }
            break;
        case 2:{
            [self selectIndexPath:indexPath];
            break;
        }
        case 3: {
            RCAddressController *addressController = [self controller];
            if(addressController.currentAddress.shareUrl.length > 0) {
                SharePopupView *shareView = [SharePopupView loadNib];
                shareView.linkLabel.text = addressController.currentAddress.shareUrl;
                shareView.didCloseAction = ^() {
                    [RCToolbarController selectPreviousItem];
                };
                [shareView displayOnView:[RCMapController currentNav].view];
                [[RCAnalyticsServicesComposite sharedInstance] trackScreenWithName:@"Share"];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
