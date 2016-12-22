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

@interface RCNearbyProjectCell ()

@property (weak, nonatomic) IBOutlet RCInteractiveImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageMissedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation RCNearbyProjectCell

- (void)setProject:(RCProject *)project {
    _project = project;
    
    self.leftImageView.image = nil;
    [self.leftImageView setImageWithURLstring:project.previewImage.url placeholderImage:IMG(@"project_preview_mini_placeholder") imageMissedView:self.imageMissedLabel];
    self.nameLabel.text = self.project.name;
    self.addressLabel.text = self.project.address;
    @weakify(self);
    self.leftImageView.tappedBlock = ^(RCInteractiveImageView *imageView) {
        @strongify(self);
        RUN_BLOCK(self.didPressedProjectImageBlock, self.project);
    };
}

@end
