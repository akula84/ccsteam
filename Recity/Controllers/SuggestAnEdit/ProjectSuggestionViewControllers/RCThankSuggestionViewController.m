//
//  RCThankSuggestionViewController.m
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCThankSuggestionViewController.h"

#import "RCSuggestionTypeTableViewController.h"

@interface RCThankSuggestionViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

@implementation RCThankSuggestionViewController

- (IBAction)back {
    UIViewController *backVC = [self firstControllerInNavigationWithClass:[RCSuggestionTypeTableViewController class]];
    [self.navigationController popToViewController:backVC
                                          animated:YES];
}

@end
