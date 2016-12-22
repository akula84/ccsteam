//
//  RCSuggestionViewController.h
//  Recity
//
//  Created by ezaji.dm on 14.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseViewController.h"

#import "RCSuggestionManager.h"

@interface RCSuggestionViewController : RCBaseViewController

@property (strong, nonatomic) RCSuggestionManager *suggestionManager;

- (IBAction)back;
- (IBAction)close;

/*
 * Search is carried out in reverse order
 */
- (UIViewController *)firstControllerInNavigationWithClass:(Class)classController;

@end
