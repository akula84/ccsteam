//
//  RCDevelopmentDetailsView.h
//  Recity
//
//  Created by Matveev on 20/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseTableViewController.h"

#import "RCDetailsSection.h"
#import "RCItemProtocol.h"

@class RCProject;

@interface RCProjectDetailsViewController : RCBaseTableViewController <RCItemProtocol>

@property (strong, nonatomic) RCProject *project;

- (void)scrollToProjectDetailsSection;
- (BOOL)sectionWithTypeIsAvailable:(DetailsSectionType)sectionType;

@end
