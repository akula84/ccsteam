//
//  RCProjectDetailsViewController+ShortDataView.m
//  Recity
//
//  Created by Artem Kulagin on 15.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController_Private.h"

#import "NSString+More.h"
#import "RCProject.h"

@implementation RCProjectDetailsViewController (ShortDataView)

- (void)prepareShortDataView
{
    RCProject *project = self.project;
    self.shortDataView.backgroundColor = [project colorForCurrentStatus];
    
    [self prepareBuildingTypeLabel];
    self.completionDateLabel.text = [project completionTimeWithYear];
    self.completionDateDescriptionLabel.text = [self topCompletionLabelText];
}

- (void)prepareBuildingTypeLabel
{
    RCProject *project = self.project;
    self.buildingTypeLabel.text = [project buildingTypeTextIfNeedMixedUse];
    [self prepareShortDataViewConstrains];
}

- (void)prepareShortDataViewConstrains
{
    NSLayoutConstraint *constrains = self.shortDataViewConstrains;
    constrains.constant = -1;
    UILabel *label = self.buildingTypeLabel;
    NSString *text = label.text;
    CGRect frame = label.frame;
    CGFloat widthText = [text widthWithFont:label.font height:CGRectGetHeight(frame)];
    CGFloat odds = widthText - CGRectGetWidth(frame);
    odds = ceilf((float)odds);
    if (odds > 0) {
        constrains.constant = constrains.constant - odds-1;
    }
}

- (NSString *)topCompletionLabelText
{
    NSString *result;
    if ([self.project projectStatus] == ProjectStatusCompleted) {
        result = @"COMPLETION\nDATE";
    } else {
        result = @"EXPECTED\nCOMPLETION";
    }
    return result;
}

@end
