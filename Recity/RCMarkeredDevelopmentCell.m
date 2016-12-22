//
//  RCMarkeredDevelopmentCell.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMarkeredDevelopmentCell.h"

@interface RCMarkeredDevelopmentCell ()

@property (assign, nonatomic) CGFloat startCommentButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelVerticalCenteringLayout;

@end

@implementation RCMarkeredDevelopmentCell

- (void)setProject:(RCProject *)project {
    [super setProject:project];

    NSString *markerImageName;
    BOOL displayPinImage = self.project.address == nil || self.project.address.length == 0 || [self.project.name isEqualToString:self.project.address];
    if (displayPinImage) {
        markerImageName = @"pin_orange";
        self.nameLabelVerticalCenteringLayout.priority = 999;
        self.nameLabel.numberOfLines = 2;
        self.addressLabel.hidden = YES;
    } else {
        markerImageName = [project projectStatusMarkerImageName];
        self.nameLabelVerticalCenteringLayout.priority = 250;
        self.nameLabel.numberOfLines = 1;
        self.addressLabel.hidden = NO;
    }
    self.leftImageView.image = IMG(markerImageName);
}

@end
