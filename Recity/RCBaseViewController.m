//
//  BaseViewController.m
//  golf-fitness
//
//  Created by Matveev on 03.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "RCBaseViewController.h"

@interface RCBaseViewController () <UIAlertViewDelegate>

@property (assign, nonatomic) BOOL wasViewWillAppear;
@property (assign, nonatomic) BOOL wasDidLoadSubviews;

@end

@implementation RCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_wasViewWillAppear) {
        if (_actionsAfterFirstViewWillAppearBlock) {
            _actionsAfterFirstViewWillAppearBlock();
        }
    }
    _wasViewWillAppear = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_wasDidLoadSubviews) {
        if (_actionsAfterFirstDidLoadSubviewsBlock) {
            _actionsAfterFirstDidLoadSubviewsBlock();
        }
    }
    _wasDidLoadSubviews = YES;
}

- (void)addGrayNetBackgroundToView:(UIView *)view {
    view.backgroundColor = [UIColor colorWithPatternImage:IMG(@"gray_net_background")];
}

//- (void)addBackButton {
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
//}
//
//- (void)addMenuButton {
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMG(@"menu_icon") style:UIBarButtonItemStylePlain target:[AppDelegate sharedInstance] action:@selector(menuButtonAction)];
//}
//
//- (void)addSearchButton {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMG(@"search_icon") style:UIBarButtonItemStylePlain target:[AppDelegate sharedInstance] action:@selector(searchButtonAction)];
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

//- (void)resignFirstResponder {
//    //      you can rewrite this method at subclass
//}

- (void)dealloc {
    NSLog(@"dealloccontroller %@", [self rc_className]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
