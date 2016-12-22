//
//  RCProjectSuggetionTableViewController.h
//  Recity
//
//  Created by ezaji.dm on 08.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCSuggestionTableViewController.h"
#import "RCSuggestionTypeTableViewController.h"

#import "RCProjectSuggestion.h"

#import "RCProject.h"

@interface RCProjectSuggestionTableViewController : RCSuggestionTableViewController

- (RCSuggestionTypeTableViewController *)suggestTypeVC;

- (IBAction)submitAction;

@end
