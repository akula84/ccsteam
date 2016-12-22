//
//  RCProjectDetailsViewController+LeftImageView.m
//  Recity
//
//  Created by Artem Kulagin on 15.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController_Private.h"

#import "RCInteractiveImageView.h"
#import "RCProject.h"
#import "RCImage.h"
#import "FLAnimatedImage.h"
#import "RCMapController.h"

@implementation RCProjectDetailsViewController (LeftImageView)

- (void)prepareLeftImageView
{
    RCProject *project = self.project;
    NSString *urlImage = project.previewImage.url;
    @weakify(self);
    [self.leftImageView setImageWithURLstring:[urlImage urlStringWithImageSize:RCImageSmall]
                           placeholderNOImage:[UIImage imageNamed:@"projectNoImage"]
                                   viewFailed:self.imageMissedLabel
                                   completion:^{
                                       @strongify(self);
                                       self.spinnerImageView.hidden = YES;
                                   }];
    self.leftImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        if (urlImage){
            @strongify(self);
            RUN_BLOCK(RCMapController.didPressedProjectImageBlock, self.project);
        }
    };
}

- (void)prepareSpinner
{
    FLAnimatedImageView *spinnerImageView = self.spinnerImageView;
    spinnerImageView.hidden = NO;
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"spinner" withExtension:@"gif"]]];
    spinnerImageView.animatedImage = image;
}

@end
