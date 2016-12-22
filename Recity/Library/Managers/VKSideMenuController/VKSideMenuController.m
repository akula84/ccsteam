//
//  VKSideMenuController.m
//  Recity
//
//  Created by Artem Kulagin on 15.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "VKSideMenuController.h"

#import "RCVKSideMenuItem.h"
#import "AboutPopupView.h"
#import "ContactUsPopupView.h"
#import "RCTutorialManager.h"
#import "RCMapController.h"

@interface VKSideMenuController()

@property (strong, nonatomic) VKSideMenu *menuLeft;

@end

@implementation VKSideMenuController
SINGLETON_OBJECT

+ (void)showMenu
{
    [[self controller].menuLeft showIn:[self currentNav]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepareMenu];
    }
    return self;
}

- (void)prepareMenu
{
    VKSideMenu *menuLeft = [[VKSideMenu alloc] initWithWidth:270 andDirection:VKSideMenuDirectionLeftToRight];
    [menuLeft prepareItems:[self menuItems]];
    self.menuLeft = menuLeft;
    menuLeft.didSelect = ^(NSIndexPath *indexPath){
        [self didSelect:indexPath];
    };
}

- (NSArray *)menuItems
{
    NSArray *firstSection = @[[RCVKSideMenuItem itemImageName:@"menuQuestion" title:@"Help / Tutorial"],
                              [RCVKSideMenuItem itemImageName:@"menuPost" title:@"Contact Us"],
                              [RCVKSideMenuItem itemImageName:@"menuBeep" title:@"About"]];
    NSArray *secondSection = @[[RCVKSideMenuItem itemImageName:@"menuExit" title:@"Sign Out"]];
    
    return @[firstSection,secondSection];
}

- (void)didSelect:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                if ([AppState sharedInstance].firstProjectsDownloadingFinished) {
                    [RCTutorialManager beginTutorial];
                } else {
                    [RCMapController showAlert];
                }
            }
                break;
            case 1:
                [self showFeedbackForm];
                break;
            case 2:
                [self showPopupView];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1){
        [self showSign];
    }
}

- (void)showSign
{
    [RCMapController close];
}

- (void)showPopupView
{
    AboutPopupView *popupView = [AboutPopupView loadNib];
    [popupView displayOnView:[self navView]];
}

- (void)showFeedbackForm
{
    ContactUsPopupView *contactUs = [ContactUsPopupView loadNib];
    [contactUs displayOnView:[self navView]];
}

- (UIView *)navView
{
    return [VKSideMenuController currentNav].view;
}

+ (UINavigationController *)currentNav
{
    return [RCMapController currentNav];
}

+ (VKSideMenuController *)controller
{
    return [VKSideMenuController shared];
}

@end
