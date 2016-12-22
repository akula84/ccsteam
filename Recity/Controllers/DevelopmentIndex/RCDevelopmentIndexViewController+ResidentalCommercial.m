//
//  RCDevelopmentIndexViewController+ResidentalCommercial.m
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexViewController_Private.h"

#import "RCAddress.h"
#import "RCPredicateFactory.h"
#import "RCSizeHelper.h"

@implementation RCDevelopmentIndexViewController (ResidentalCommercial)

- (void)updateResidentialCommercial
{
    [self setResidentialPercentValue:[self residentialProcentage]];
}

- (CGFloat)residentialProcentage
{
    NSArray *nearbyProjects = [[self.address nearbyProject] filteredArrayUsingPredicate:[RCPredicateFactory predPlanned]];
    
    if (nearbyProjects.count > 2) {
        NSArray *residential = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsResidential]];
        NSArray *commercial = [nearbyProjects filteredArrayUsingPredicate:[RCPredicateFactory predTypeDetailsCommercial]];
        
        CGFloat residentalSize =  [[residential valueForKeyPath:@"@sum.typeDetails.residentialSize"] floatValue];
        residentalSize += [[residential valueForKeyPath:@"@sum.typeDetails.estimatedResidentialSize"] floatValue];
        
        CGFloat commercialSize = [[commercial valueForKeyPath:@"@sum.typeDetails.officeSize"] floatValue];
        commercialSize += [[commercial valueForKeyPath:@"@sum.typeDetails.estimatedOfficeSize"] floatValue];
        
        CGFloat summ = residentalSize + commercialSize;
        
        CGFloat residentialProcentage = residentalSize / (summ / 100.0f);
        
        return residentialProcentage;
    }

    return -1;
}

- (void)setResidentialPercentValue:(CGFloat)percent
{
    if (percent == -1) {
        [self setRCViewHidden:YES];
    } else {
        [self setRCViewHidden:NO];
        CGFloat width = CGRectGetWidth(self.procentageBar.frame);
        CGFloat onePercentInPoints = width/100.0f;
        
        self.deviderPositionConstraint.constant = percent * onePercentInPoints;
        
        self.residentalPercentLabel.text = [NSString stringWithFormat:@"%.0f %%", percent];
        self.commercialPercentLabel.text = [NSString stringWithFormat:@"%.0f %%", 100 - percent];
        
        self.residentalPercentBubble.hidden = self.deviderPositionConstraint.constant < 67.0f;
        self.commercialPercentBubble.hidden = percent > 85.0f;
        
        BOOL residentialWin = percent > 50.0f;
        
        UIColor *residentialColor = residentialWin ? kMediumOrangeColor : kLightedDarkPurpleColor;
        UIColor *commercialColor = residentialWin ? kLightedDarkPurpleColor : kMediumOrangeColor;
        
        self.residentialBar.backgroundColor = residentialColor;
        self.residentialIcon.tintColor = residentialColor;
        self.residentialLabel.textColor = residentialColor;
        
        self.commercialBar.backgroundColor = commercialColor;
        self.commercialIcon.tintColor = commercialColor;
        self.commercialLabel.textColor = commercialColor;
    }
}

- (void)setRCViewHidden:(BOOL)hidden
{
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    if (hidden) {
        headerFrame.size.height = [RCSizeHelper detailsHalfHeight];
    } else {
        headerFrame.size.height = [RCSizeHelper detailsHalfHeight] + 136.0f;
    }
    self.tableView.tableHeaderView.frame = headerFrame;
    self.rcView.hidden = hidden;
    self.tableView.tableHeaderView = self.tableView.tableHeaderView;
}

@end
