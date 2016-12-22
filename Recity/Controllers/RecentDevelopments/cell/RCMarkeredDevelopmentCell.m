//
//  RCMarkeredDevelopmentCell.m
//  Recity
//
//  Created by Matveev on 19/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMarkeredDevelopmentCell.h"

#import "RCAddress.h"
#import "RCProject.h"
#import "RCInteractiveImageView.h"

@interface RCMarkeredDevelopmentCell ()

@property (assign, nonatomic) CGFloat startCommentButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelVerticalCenteringLayout;

@end

@implementation RCMarkeredDevelopmentCell

- (void)setItem:(id)item
{
    [super setItem:item];

    NSString *markerImageName = @"";
    if ([item isKindOfClass:[RCProject class]]) {
        RCProject *project = (RCProject *)self.item;
        BOOL displayPinImage = project.address == nil || project.address.length == 0;
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
    }
    if ([item isKindOfClass:[RCAddress class]]) {
        markerImageName = @"pin_orange";
    }
  
    self.leftImageView.image = IMG(markerImageName);
    
}

@end
