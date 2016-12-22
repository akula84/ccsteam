//
//  RCDINearbyTypesProjectCell.m
//  Recity
//
//  Created by Vitaliy Zhukov on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDINearbyTypesProjectCell.h"

#import "RCProject.h"
#import "RCAddress.h"
#import "RCImage.h"
#import "NSNumber+Grouped.h"
#import "UIImageView+AFNetworking.h"

@interface RCDINearbyTypesProjectCell()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end

@implementation RCDINearbyTypesProjectCell

- (void)updateWithProject:(RCProject *)project andAddress:(RCAddress *)address
{
    self.nameLabel.text = project.name;
    self.addressLabel.text = [[project address] uppercaseString];
    self.cityLabel.text = [[project cityName] uppercaseString];
    self.statusLabel.text = [project statusString];
    self.statusImageView.image = IMG([project projectStatusMarkerImageName]);
    
    CLLocationDistance distance = [RCProject distanceBetweenPoint1:[address coordinate] point2:[project coordinate]];
    
    CGFloat miles = (CGFloat)distance * 0.000621371f;
    
    NSString *distString = [NSString stringWithFormat:@"%.1f", miles];
    distString = [distString stringByReplacingOccurrencesOfString:@"0." withString:@"."];
    if ([distString isEqualToString:@".0"]) {
        distString = @"<.1";
    }
    distString = [distString stringByAppendingString:@" MI AWAY"];
    
    self.distanceLabel.text = distString;
    
    NSNumber *area = nil;
    
    if (project.buildingSize) {
        area = [project buildingSize];
    } else {
        area = [project estimatedBuildingSize];
    }
    self.areaLabel.text = [NSString stringWithFormat:@"%@ SQ FT", [area groupSqFT]];
    
    [self.pictureView setImageWithURL:[NSURL URLWithString:project.previewImage.url] placeholderImage:IMG(@"projectNoImage")];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}

@end
