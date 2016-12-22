//
//  RCCondosApartmentsView.m
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCCondosApartmentsView.h"

#import "RCCondosApartmentsMetric.h"
#import "NSNumber+Grouped.h"

static CGFloat kEdgeImage = 9.f;

@interface RCCondosApartmentsView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *condosCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *aptsCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *condosUpcomingLabel;
@property (weak, nonatomic) IBOutlet UILabel *aptsUpcomingLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTbdLabel;
@property (weak, nonatomic) IBOutlet UIView *projectTbdView;

@property (strong, nonatomic) RCCondosApartmentsMetric *model;

@end


@implementation RCCondosApartmentsView

- (CGFloat)widthGraph
{
    CGFloat widthScreen = [[UIScreen mainScreen] bounds].size.width;
    return widthScreen - self.leftConstraint.constant - self.rightConstraint.constant;
}

- (void)setModel:(RCCondosApartmentsMetric *)model
{
    _model = model;
    
    [self prepareImage];
    [self preparePositionImageView];
    [self prepareProjectTbdView];
    [self prepareLabels];
}

- (void)prepareProjectTbdView
{
    self.projectTbdView.hidden = !self.model.projectTbd.isFull;
}

- (void)prepareLabels
{
    RCCondosApartmentsMetric *model = self.model;
    self.condosCompleteLabel.text = [model.condosComplete groupDigit];
    self.aptsCompleteLabel.text = [model.aptsComplete groupDigit];
    self.condosUpcomingLabel.text = [model.condosUpcoming groupDigit];
    self.aptsUpcomingLabel.text = [model.aptsUpcoming groupDigit];
    self.projectTbdLabel.text = [model.projectTbd groupDigit];
}

- (void)preparePositionImageView
{
    CGFloat fullWidth = [self widthGraph] - kEdgeImage * 2;
    RCCondosApartmentsMetric *model = self.model;
    float condos = model.condosTotal.floatValue;
    float apts = model.aptsTotal.floatValue;
    CGFloat ratio = apts/(condos + apts);
    self.imageViewConstraint.constant = kEdgeImage + fullWidth * ratio;
}

- (void)prepareImage
{
    RCCondosApartmentsMetric *model = self.model;
    float condos = model.condosTotal.floatValue;
    float apts = model.aptsTotal.floatValue;
    NSString *imageName;
    if (condos > apts) {
        imageName = @"leftArrowMetric";
    } else if (condos < apts){
        imageName = @"rightArrowMetric";
    } else {
        imageName = @"";
    }
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

@end
