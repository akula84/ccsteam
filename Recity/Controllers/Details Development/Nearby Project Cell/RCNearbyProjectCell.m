//
//  RCNearbyProjectCell.m
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCNearbyProjectCell.h"

#import "RCProject.h"
#import "RCImage.h"
#import "RCInteractiveImageView.h"
#import "UIFont+RecityFont.h"
#import "RCMapController.h"
#import "RCDetailController.h"
#import "RCFloatViewSliderController.h"

static CGFloat betweenWidth =  102.f;
static CGFloat betweenHeight =  20.f;

@interface RCNearbyProjectCell ()

@property (weak, nonatomic) IBOutlet RCInteractiveImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageMissedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation RCNearbyProjectCell

- (void)setProject:(RCProject *)project
{
    _project = project;
    self.leftImageView.image = nil;
    
    NSString *projectImageUrlThumbnail = [project.previewImage.url urlStringWithImageSize:RCImageThumbnail];
    [self.leftImageView setImageWithURLstring:projectImageUrlThumbnail
                           placeholderNOImage:[UIImage imageNamed:@"projectNoImage"]
                                   viewFailed:self.imageMissedLabel
                                   completion:nil];
    
    self.nameLabel.text = self.project.name;
    self.addressLabel.text = self.project.address;
    
    @weakify(self);
    self.leftImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        @strongify(self);
        if(projectImageUrlThumbnail) {
            RUN_BLOCK([RCMapController didPressedProjectImageBlock], self.project);
        } else {
            [RCDetailController scrollToProjectDetailsSection];
            [RCMapController showItem:self.project];
            [RCFloatViewSliderController displayHalfscreen];
        }
    };
}

+ (CGFloat)height:(RCProject *)project
{
    UIFont *font = [UIFont flamaBook:12.f];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - betweenWidth - kCellInsets;
    
    CGFloat nameHeight = [project.name  heightWithFont:font width:width];
    CGFloat addressHeight = [project.address  heightWithFont:font width:width];
    
    return nameHeight + addressHeight + betweenHeight;
}

+ (CGFloat)defaultHeight
{
    return 50.f;
}

@end
