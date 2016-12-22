//
//  RCDevelopmentDetailsView.h
//  Recity
//
//  Created by Matveev on 20/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCBaseTableViewController.h"
#import "RCProject.h"
#import "RCDetailsSection.h"

@interface RCProjectDetailsViewController : RCBaseTableViewController

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) RCProject *project;

@property (strong, nonatomic) DidPressedProjectImageBlock didPressedProjectImageBlock;
@property (readonly, assign, nonatomic) CGFloat halfDisplayedFloatViewHeight;
@property (readonly, assign, nonatomic) CGFloat originalMainHeaderViewHeight;

- (void)scrollToProjectDetailsSection;
- (void)scrollToNotesSection;
- (void)scrollToNearestSection;

- (BOOL)sectionWithTypeIsAvailable:(DetailsSectionType)sectionType;

@end
