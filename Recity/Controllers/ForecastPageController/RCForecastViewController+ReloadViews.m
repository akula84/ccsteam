//
//  RCForecastViewController+ReloadViews.m
//  Recity
//
//  Created by Artem Kulagin on 06.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastViewController_Private.h"

#import "RCProject.h"
#import "NSNumber+Grouped.h"
#import "NSNumber+CLLocationDistance.h"
#import "RCAddress.h"
#import "RCTypeDetails.h"
#import "RCPredicateFactory.h"
#import "RCIndexUtils.h"
#import "CGRect+Utils.h"

@implementation RCForecastViewController (ReloadViews)

- (void)prepareNoData
{
    [self allTopHidden];
    [self cardHidden:YES];
    
    self.titleLabel.alpha = 1.f;
    self.subTitleLabel.alpha = 1.f;
}

- (void)reloadTop
{
    [self allTopHidden];
     
    RCProject *project = [self currentProject];
    self.dateLabel.hidden = NO;
    self.dateLabel.text = [project completionTimeWithYear];
    
    NSUInteger index = (NSUInteger)[self currentIndexPath].item;
    [self backViewsValue:index];
    [self forwardViewsValue:index];
}

- (void)backViewsValue:(NSUInteger)index
{
    if (index == 0) {return;}
    self.backLabel.text = [NSString stringWithFormat:@"%@",@(index)];
    [self backViewsHidden:NO];
}

- (void)forwardViewsValue:(NSUInteger)index
{
    NSUInteger countAll = self.projects.count;
    if (index == (countAll- 1)) {return;}
    NSUInteger indexForward = countAll - index - 1;
    self.forwardLabel.text = [NSString stringWithFormat:@"%@",@(indexForward)];
    [self forwardViewsHidden:NO];
}

- (void)allTopHidden
{
    self.dateLabel.hidden = YES;
    [self backViewsHidden:YES];
    [self forwardViewsHidden:YES];
}

- (void)backViewsHidden:(BOOL)hidden
{
    self.backLabel.hidden = hidden;
    self.backView.hidden = hidden;
}

- (void)forwardViewsHidden:(BOOL)hidden
{
    self.forwardLabel.hidden = hidden;
    self.forwardView.hidden = hidden;
}

- (void)cardHidden:(BOOL)hidden
{
    CGFloat alpha = hidden?0.f:1.f;
    for (UIView *view in self.cardViews) {
        view.alpha = alpha;
    }
}

- (void)reloadCard
{
    RCProject *project = [self currentProject];
    
    self.titleLabel.text = project.name;
    self.subTitleLabel.text = [[project extendedAddress] uppercaseString];
    [self prepareDistanceLabel];
    self.typeLabel.text = [project buildingTypeTextIfNeedMixedUse];
    self.statusLabel.text = [project statusString];
    [self prepareTypeButton];
    [self prepareCountLabel];
}

- (void)prepareDistanceLabel
{
    RCProject *project = [self currentProject];
    CLLocationDistance distance = [project distanceBetweenPoint:[self.address coordinate]];
    CLLocationDistance miles = [@(distance) kmToMiles].doubleValue/1000;
    NSString *distanceString = [@(miles) roundOneDecimalUp];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ miles",distanceString];
}

- (void)prepareTypeButton
{
    RCProject *project = [self currentProject];
    UIButton *typeButton = self.typeButton;
    UIImage *image = [project mapPinImageForCurrentUser];
    [typeButton setImage:image forState:UIControlStateNormal];
    [typeButton setImage:image forState:UIControlStateHighlighted];
}

- (void)prepareCountLabel
{
    RCProject *project = [self currentProject];
    if (!project) {return;}
    NSString *string;
    if ([self isResidential]){
        string = [NSString stringWithFormat:@"%@ Units",[RCIndexUtils valueResidentialUnits:@[project]]];
    }else if ([self isRetailorHotel]){
        string = [NSString stringWithFormat:@"%@ Rooms",project.typeDetails.numberOfHotelRooms];
    }else if ([self isRetailorOffice]){
        NSNumber *sum = [RCIndexUtils valueOfficeAndRetail:@[project]];
        string = [NSString stringWithFormat:@"%@ SF",[sum groupPlanned]];
    }else {
        string = @"TBD";
    }
    self.countLabel.text = string;
}

- (BOOL)isResidential
{
    return [self isTypeProject:[RCPredicateFactory predTypeDetailsResidential]];
}

- (BOOL)isRetailorHotel
{
    return [self isTypeProject:[RCPredicateFactory predTypeDetailsHotel]];
}

- (BOOL)isRetailorOffice
{
    return [self isTypeProject:[RCPredicateFactory predTypeDetailsOfficeAndRetail]];
}

- (BOOL)isTypeProject:(NSPredicate *)predicate
{
    return [@[self.currentProject] filteredArrayUsingPredicate:predicate].isFull;
}

- (void)updateImageBackground
{
    CGPoint point = self.collectionView.contentOffset;
    UIImageView *imageBackground = self.imageBackground;
    CGFloat offsetX = - 60.f - point.x/15.f;
    imageBackground.frame = CGRectSetX(imageBackground.frame,offsetX);
    
    UIImageView *additionalImageBackground = self.additionalImageBackground;
    additionalImageBackground.frame = CGRectSetX(additionalImageBackground.frame, offsetX + imageBackground.frame.size.width);
}

@end
