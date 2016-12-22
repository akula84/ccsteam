//
//  RCMapController.m
//  Recity
//
//  Created by Artem Kulagin on 29.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapController.h"

#import "RCProject.h"
#import "RCAddressApi.h"
#import "RCAddress.h"
#import "MyLocationButtonController.h"
#import "RCImage.h"
#import "RCImageViewer.h"

@interface RCMapController()

@property (strong, nonatomic) RCImageViewer *imageViewer;

@end

@implementation RCMapController
SINGLETON_OBJECT

+ (void)prepareDefaultTitle
{
    RUN_BLOCK([self controller].didDefaultTitle);
}

+ (void)updateNearbyProjects
{

    RUN_BLOCK([self controller].didUpdateNearbyProjects);
}

+ (void)showMyLocation
{
    RUN_BLOCK([self controller].didShowMyself);
}

+ (void)showItem:(id)item
{
    RUN_BLOCK([self controller].didShowItem,item);
}

+ (void)showIndexFromMyLocation:(CLLocation *)location
{
    NSNumber *latitude = @(location.coordinate.latitude);
    NSNumber *longitude = @(location.coordinate.longitude);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude, longitude];
    RCAddress *address = [RCAddress MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    
    if (!address) {
        address = [RCAddress MR_createEntity];
        address.latitude = latitude;
        address.longitude = longitude;
    }
    [self showItem:address];
    [MyLocationButtonController prepareActived:YES];
}

+ (void)reloadVisibleAddress
{
    RUN_BLOCK([self controller].didReloadVisibleAddress);
}

+ (RCProject *)selectedProject
{
    id item = [self selectedItem];
    RCProject *project;
    if ([item isKindOfClass:[RCProject class]]) {
        project = item;
    }
    return project;
}

+ (RCAddress *)selectedAddress
{
    id item = [self selectedItem];
    RCAddress *address;
    if ([item isKindOfClass:[RCAddress class]]) {
        address = item;
    }
    return address;
}

+ (id)selectedItem
{
    return [self controller].selectedItem;
}

+ (RCMapController *)controller
{
    return [RCMapController  shared];
}

+ (void)selectedClear
{
    [self controller].selectedItem = nil;
}

+ (void)showAlert
{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:nil message:LOC(@"List of project is empty. Please try again later") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:({
        [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    })];
    [(UIViewController *)[self controller].mapView presentViewController:alertController animated:YES completion:nil];
}

+ (DidPressedProjectImageBlock)didPressedProjectImageBlock
{
    [self controller].imageViewer = [RCImageViewer new];
    @weakify(self);
    DidPressedProjectImageBlock block = ^(RCProject *project) {
        @strongify(self);
        NSMutableArray *imagesOrUrls = [@[] mutableCopy];
        for (RCImage *currentImage in project.images) {
            if (currentImage.url) {
                [imagesOrUrls addObject:[NSURL URLWithString:[currentImage.url urlStringWithImageSize:RCImageLarge]]];
            }
        }
        [[self controller].imageViewer pushInNavigationVC:self.currentNav imagesOrUrls:imagesOrUrls];
    };
    return block;
}

+ (UINavigationController *)currentNav
{
    return [(UIViewController *)[self controller].mapView  navigationController];
}

+ (void)close
{
    [AppState logOut:^{
        [[RCAnalyticsServicesComposite sharedInstance] startNewSession];
        [[self currentNav] dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
