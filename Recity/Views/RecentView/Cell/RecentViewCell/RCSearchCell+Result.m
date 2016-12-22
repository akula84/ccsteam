//
//  RCSearchCell+Result.m
//  Recity
//
//  Created by Artem Kulagin on 02.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSearchCell.h"

#import "RCAddress.h"
#import "RCProject.h"
#import "RCSearchCell_Private.h"
#import "RCSearchManager.h"

@implementation RCSearchCell (Result)

- (void)prepareResultItem:(id)item
{
    [self prepareAllHide];
    if ([item isKindOfClass:[RCProject class]]) {
        [self prepareResultProject:item];
    } else if ([item isKindOfClass:[RCAddress class]]) {
        [self prepareResultAddress:item];
    }
}

- (void)prepareResultTitle
{
    [self prepareAllHide];
    [self prepareImage:@"searchOrange"];
    NSString *title =[RCSearchManager shared].searchText;
    [self prepareCenterLabelText:title];
}

- (void)prepareResultProject:(id)item
{
    RCProject *project = (RCProject *)item;

    [self prepareImage:@"searchDot"];
    self.myImageView.tintColor = [project colorForCurrentStatus];
    
    self.projectLabel.hidden = NO;
    self.projectLabel.text = project.name;
    self.projectSubLabel.hidden = NO;
    self.projectSubLabel.text = project.address;
}

- (void)prepareResultAddress:(id)item
{
    RCAddress *locationAddress = (RCAddress *)item;
    [self prepareImage:@"searchPin"];
    [self prepareCenterLabelText:locationAddress.address];
}

@end
