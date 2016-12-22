//
//  RCProjectDetailsViewController+ShortDataView.h
//  Recity
//
//  Created by Artem Kulagin on 15.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectDetailsViewController.h"

@class RCInteractiveImageView,FLAnimatedImageView;

@interface RCProjectDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *shortDataView;
@property (weak, nonatomic) IBOutlet UILabel *buildingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionDateDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageMissedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortDataViewConstrains;
@property (weak, nonatomic) IBOutlet RCInteractiveImageView *leftImageView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *spinnerImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) RCDetailsSection *developmentIndexSection;

- (void)scrollToNotesSection;
- (void)scrollToNearestSection;

@end

@interface RCProjectDetailsViewController (ShortDataView)

- (void)prepareShortDataView;

@end

@interface RCProjectDetailsViewController (LeftImageView)

- (void)prepareLeftImageView;
- (void)prepareSpinner;

@end

@interface RCProjectDetailsViewController (TopView)

- (void)prepareTopView;

@end

@interface RCProjectDetailsViewController (TableManager)

- (void)prepareTableManager;

@end

@interface RCProjectDetailsViewController (Controller)

- (void)prepareDetailController;

@end

@interface RCProjectDetailsViewController (UserNotes)

- (void)prepareUserNotesHandler;
- (void)cleanUserNotesHandler;

@end

