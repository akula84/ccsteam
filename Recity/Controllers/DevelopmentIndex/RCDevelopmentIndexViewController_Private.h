//
//  RCDevelopmentIndexViewController_Private.h
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexViewController.h"
#import "RCDevelopmentIndexTableViewCell.h"

#import "RCAddressController.h"

@class RCDevelopmentIndexRoundGraph, RCDevelopmentIndexOutlookGraph, M13ProgressViewBar;

@interface RCDevelopmentIndexViewController ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

//Graphs view
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet M13ProgressViewBar *progressBar;
@property (weak, nonatomic) IBOutlet RCDevelopmentIndexRoundGraph *roundGraph;
@property (weak, nonatomic) IBOutlet RCDevelopmentIndexOutlookGraph *outlookGraph;
@property (weak, nonatomic) IBOutlet UILabel *outlookGraphTitle;
@property (weak, nonatomic) IBOutlet UIView *mainGraphsView;

//Residental vs Commercial
@property (weak, nonatomic) IBOutlet UIView *rcView;
@property (weak, nonatomic) IBOutlet UIView *residentalPercentBubble;
@property (weak, nonatomic) IBOutlet UIView *commercialPercentBubble;
@property (weak, nonatomic) IBOutlet UILabel *residentalPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commercialPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *residentialIcon;
@property (weak, nonatomic) IBOutlet UIImageView *commercialIcon;
@property (weak, nonatomic) IBOutlet UILabel *residentialLabel;
@property (weak, nonatomic) IBOutlet UILabel *commercialLabel;
@property (weak, nonatomic) IBOutlet UIView *residentialBar;
@property (weak, nonatomic) IBOutlet UIView *commercialBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderPositionConstraint;
@property (weak, nonatomic) IBOutlet UIView *procentageBar;

//
@property (strong, nonatomic) NSIndexPath *currentOpenedIndexPath;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightGraph;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTitle;

@end

@interface RCDevelopmentIndexViewController (ResidentalCommercial)

- (void)updateResidentialCommercial;

@end

@interface RCDevelopmentIndexViewController (TableView)  <UITableViewDelegate, UITableViewDataSource, RCDevelopmentIndexTableViewCellDelegate>

- (void)setupTableObserver:(BOOL)enabled;

@end

@interface RCDevelopmentIndexViewController (Action)

@end
