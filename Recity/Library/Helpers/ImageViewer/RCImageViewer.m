//
//  RCImageViewer.m
//  Recity
//
//  Created by Matveev on 21/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCImageViewer.h"
#import "MWPhotoBrowser.h"

@interface RCImageViewer () <MWPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableArray *imagesOrUrls;
@property (strong, nonatomic) MWPhotoBrowser *browser;

@end

@implementation RCImageViewer

- (void)presentInVC:(UIViewController *)vc imagesOrUrls:(NSArray *)imagesOrUrls {
    [self prepareWithImagesOrUrls:imagesOrUrls];
    [vc presentViewController:self.browser animated:YES completion:nil];
}

- (void)pushInNavigationVC:(UINavigationController *)nc imagesOrUrls:(NSArray *)imagesOrUrls {
    [self prepareWithImagesOrUrls:imagesOrUrls];
    __unused UIView *view = self.browser.view;
    
    [nc pushViewController:self.browser animated:YES];
}

- (void)prepareWithImagesOrUrls:(NSArray *)imagesOrUrls {
    self.imagesOrUrls = [@[] mutableCopy];
    
    for (id currentObject in imagesOrUrls) {
        if ([currentObject isKindOfClass:[NSURL class]]) {
            [self.imagesOrUrls addObject:[MWPhoto photoWithURL:currentObject]];
        } else {
            [self.imagesOrUrls addObject:[[MWPhoto alloc] initWithImage:currentObject]];
        }
    }
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    self.browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    self.browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    self.browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    self.browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    self.browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    self.browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    self.browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    self.browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    self.browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    self.browser.customImageSelectedIconName = @"ImageSelected.png";
    self.browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [self.browser setCurrentPhotoIndex:0];
    [self.browser showNextPhotoAnimated:YES];
    [self.browser showPreviousPhotoAnimated:YES];
}

#pragma mark - MWPhotoBrowserDelegate DELEGATE

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imagesOrUrls.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    id result;
    if (index < self.imagesOrUrls.count) {
        result = [self.imagesOrUrls objectAtIndex:index];
    }
    return result;
}

@end
