//
//  RCProjectSuggetionTableViewController.m
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCProjectSuggestionTableViewController.h"

#import "RCThankSuggestionViewController.h"

#import "RCRoundedImageView.h"

#import "RCErrorReporter.h"

@interface RCProjectSuggestionTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describingLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RCProjectSuggestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RCProject *project = self.suggestionManager.project;
    self.nameLabel.text = project.name;
    self.describingLabel.text = [[project extendedAddress] uppercaseString];
    
    self.submitButton.layer.borderWidth = 1.25f;
    self.submitButton.layer.borderColor = RGB(46, 49, 146).CGColor;
   
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(leftSwipeHandle:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipe];
}

- (RCSuggestionTypeTableViewController *)suggestTypeVC {
    RCBaseNavigationController *nav = (RCBaseNavigationController *)self.navigationController;
    RCSuggestionTypeTableViewController *suggestTypeVC = nil;
    NSEnumerator *reverseEnumerator = nav.viewControllers.reverseObjectEnumerator;
    while((suggestTypeVC = reverseEnumerator.nextObject)) {
        if([suggestTypeVC isKindOfClass:[RCSuggestionTypeTableViewController class]]) break;
    }
    return suggestTypeVC;
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    [self back];
}

- (IBAction)submitAction {
    self.submitButton.enabled = NO;
    
    [self.suggestionManager sumbitSuggestionWithCompletion:^(id reply, NSError *error, BOOL *handleError) {
        if (error) {
            [RCErrorReporter reportErrorIfNeeded:error
                              fromViewController:self];
        } else {
            RCThankSuggestionViewController *thankSuggestionVC = [[RCThankSuggestionViewController alloc] initWithNibName:@"RCThankSuggestionView"
                                                                                                                   bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:thankSuggestionVC
                                                 animated:YES];
            self.submitButton.enabled = YES;
        }
    }];
}

- (void)configureCell:(RCSuggestionTableCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell
             atIndexPath:indexPath];
    RCRoundedImageView *imageView = (RCRoundedImageView *)cell.imageItem;
    [imageView setImageName:[self.suggestionManager imageNamedByIndex:(NSUInteger)indexPath.row]];
}

@end
