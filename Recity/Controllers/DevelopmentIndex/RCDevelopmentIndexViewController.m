//
//  RCDevelopmentIndexViewController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 20.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexViewController_Private.h"

#import "RCAddress.h"
#import "RCDevelopmentIndexRoundGraph.h"
#import "RCDevelopmentIndexOutlookGraph.h"
#import "RCAreaPermitMetric.h"
#import "RCFloatViewSliderController.h"
#import "FavoriteHelper.h"
#import "RCToolbarController.h"
#import "M13ProgressViewBar.h"
#import "RCDragDetectorController.h"
#import "RCSizeHelper.h"
#import "RCMapController.h"

#import "RCErrorReporter.h"

@interface RCDevelopmentIndexViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonForecast;

@end

@implementation RCDevelopmentIndexViewController

- (void)updateBindings
{
    [RCFloatViewSliderController setNoDetectTableView:self.tableView];
    [self prepareAppVersion];
    [self prepareGraphs];
    [FavoriteHelper checkFavorite:self.address favoriteButton:self.favoriteButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareHeightPreView];
    [self prepareTopView];
    [self setupTableObserver:YES];
    [self prepareDragDetectorGraphs];
    [self prepareAddressController];
}

- (void)prepareAddressController
{
    [RCAddressController shared].currentAddress = self.address;
}

- (void)prepareDragDetectorGraphs
{
    BOOL advanced = [AppState advancedVersion];
    if (!advanced) {
        [RCDragDetectorController addNoProccessView:self.buttonForecast];
    }
}

- (void)prepareHeightPreView
{
    self.heightGraph.constant = [RCSizeHelper detailsHalfHeight] - self.heightTitle.constant;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollToTop];
}

- (void)prepareAppVersion
{
    BOOL advanced = [AppState advancedVersion];
    self.rcView.hidden = !advanced;
    
    [self updateResidentialCommercial];
    
    if (!advanced) {
        [RCFloatViewSliderController displayHalfscreenIfFull:nil];
    }
}

- (void)dealloc
{
    [self setupTableObserver:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateResidentialCommercial];
}

- (void)prepareTopView
{
    if (self.address.address.isFull) {
        self.addressLabel.text = [self.address placeNameIsHave];
        self.cityLabel.text = self.address.cityName;
    } else {
        self.addressLabel.text = @"";
        self.cityLabel.text = @"";
    }
}

- (void)prepareGraphs
{
    if (self.address.developmentIndex.floatValue > 0 && self.address.overallInsightType.integerValue > 0 && self.address.shareUrl.isFull) {
        self.progressView.alpha = 0.0f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateViewsWithAddress:self.address];
        });
        [self loadNewIndexDataWithUpdatedViews:NO];
    } else {
        self.progressBar.indeterminate = YES;
        self.progressBar.primaryColor = kMediumOrangeColor;
        self.progressBar.secondaryColor = kDarkPurpleColor;
        [RCToolbarController setIndexForDevelopmentIndexCell:nil];
        
        [self loadNewIndexDataWithUpdatedViews:YES];
    }
}

- (void)loadNewIndexDataWithUpdatedViews:(BOOL)updated
{
    completeAddressIndex complete = NULL;
    if(updated) {
        complete = ^(RCAddress *address, NSError *error) {
            [UIView animateWithDuration:0.3f animations:^{
                self.progressView.alpha = 0.0f;
            }];
            
            if(error) {
                [RCErrorReporter reportErrorIfNeeded:error fromViewController:self];
            }
            
            [self updateViewsWithAddress:address];
            [self reloadAreaPermitMetric];
        };
    }
    
    [self.address downloadDevelopmentIndex:complete];
}

- (void)updateViewsWithAddress:(RCAddress *)address
{
    if (address) {
        [self setGraphsEnabled:YES];
        
        self.cityLabel.text = [address cityName];
        self.addressLabel.text = address.address;
        
        [self.roundGraph setIndex:address.developmentIndex.floatValue animated:YES];
        [self.outlookGraph setGraphType:address.overallInsightType.integerValue];
        
        self.outlookGraphTitle.text = [self.outlookGraph description];
        
        [RCToolbarController setDisabledLoadAddressMode:NO];
        [RCToolbarController setIndexForDevelopmentIndexCell:self.address.developmentIndex];
    } else {
        [self setGraphsEnabled:NO];
    }
}

- (void)setGraphsEnabled:(BOOL)enabled
{
    self.mainGraphsView.backgroundColor = enabled ? kLightedDarkPurpleColor : [UIColor lightGrayColor];
    self.mainGraphsView.userInteractionEnabled = enabled;
    self.favoriteButton.hidden = !enabled;
    
    if (!enabled) {
        self.addressLabel.text = @"Unsupported area";
        self.outlookGraphTitle.text = @"Outside of Coverage Area";
    }
}

- (void)reloadAreaPermitMetric
{
    NSArray *array = self.address.metricsModel;
    for (id item in array) {
        if ([item isKindOfClass:[RCAreaPermitMetric class]]) {
            [((RCAreaPermitMetric *)item) loadData];
        }
    }
}

- (void)scrollToTop
{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)scrollToMetrics
{
    [self.tableView setContentOffset:CGPointMake(0, 176.0f) animated:YES];
}

@end
