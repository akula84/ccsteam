//
//  RCDescribingProjectViewController.m
//  Recity
//
//  Created by ezaji.dm on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDescribingProjectViewController.h"

@interface RCDescribingProjectViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;

@end

@implementation RCDescribingProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupGesture];
}

- (void)setupUI
{
    RCProject *project = self.suggestionManager.project;
    self.nameLabel.text = project.name;
    self.describingLabel.text = [[project extendedAddress] uppercaseString];
}

- (void)setupGesture
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(back)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipe];
}

@end
