//
//  RCTutorialSinglePageViewController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTutorialSinglePageViewController.h"

#import "RCTutorialPageModel.h"

@interface RCTutorialSinglePageViewController()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *blueStatusText;

@property (strong, nonatomic) RCTutorialPageModel *model;

@end

@implementation RCTutorialSinglePageViewController

+ (instancetype)pageWithModel:(RCTutorialPageModel *)model
{
    RCTutorialSinglePageViewController *controller = [RCTutorialSinglePageViewController instantiateFromStoryboardNamed:@"Tutorial"];
    controller.model = model;
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateWithModel];
}

- (void)updateWithModel
{
    self.titleLabel.text = self.model.title;
    self.textLabel.text = self.model.text;
    self.imageView.hidden = !self.model.needShowImage;
    self.blueStatusText.text = [AppState advancedVersion] ? @"Planned/\nUnannounced" : @"Planned";
}

@end
