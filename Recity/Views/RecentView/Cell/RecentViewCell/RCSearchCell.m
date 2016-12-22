//
//  RecentViewCell.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchCell.h"
#import "RCSearchCell_Private.h"

@implementation RCSearchCell

- (void)prepareAllHide
{
    self.titleRecent.hidden = YES;
    self.centerLabel.hidden = YES;
    self.projectLabel.hidden = YES;
    self.projectSubLabel.hidden = YES;
    self.myImageView.hidden = YES;
}

- (void)prepareImage:(NSString *)imageName
{
    self.myImageView.hidden = NO;
    [self.myImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)prepareCenterLabelText:(NSString *)text
{
    self.centerLabel.hidden = NO;
    self.centerLabel.text = text;
}

+ (CGFloat)height
{
    return 66.f;
}

@end
