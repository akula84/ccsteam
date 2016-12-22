//
//  RCRCProjectTenantCell.m
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectTenantCell.h"

#import "RCProjectDetail.h"

@interface RCProjectTenantCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;

@end

@implementation RCProjectTenantCell

- (void)setDetail:(RCProjectDetail *)detail
{
    self.leftImageView.image = nil;
    if (detail.image) {
        self.leftImageView.image = [Utils image:detail.image maskedByColor:[UIColor whiteColor]];
    }
    self.describingLabel.text = detail.title;
    
    BOOL useDarkColor = (detail.row % 2 == 0);
    if (useDarkColor) {
        self.leftImageView.backgroundColor = kCellPurpleColor;
    } else {
        self.leftImageView.backgroundColor = kCellLightPurpleColor;
    }
}

@end
