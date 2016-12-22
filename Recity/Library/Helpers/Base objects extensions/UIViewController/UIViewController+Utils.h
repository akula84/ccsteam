//
//  UIViewController+Utils.h
//  Dishero
//
//  Created by El-Machine on 04.07.14.
//  Copyright (c) 2014 Dishero Inc. All rights reserved.
//

@import UIKit;

@interface UIViewController (Utils)

/**
 *   Transparently creates controller using internal logic
 */
+ (__kindof UIViewController *)controller;

/**
 *  Returns view controller instanceted from this controller's storyboard with id
 *
 *  @param identifier Identifier to find and instancate controller
 *
 *  @return Instanceted controller
 */
+ (__kindof UIViewController *)controllerWithIdentifier:(NSString *)identifier;

/**
 *  Returns initial view controller of this controller storyboard
 */
+ (__kindof UIViewController *)initialController;

/**
 *  Storyboard where this controller defined
 */
+ (UIStoryboard *)storyboard;

/**
 *  Returns default identifier to instantate controller from storyboard
 *
 *  @return Identifier
 */
+ (NSString *)identifierToInstantiate;

/**
 *  Returns to previous view
 *
 *  @param segue Unwind segue
 */
- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue;

@end

@interface UIViewController (Navigation)

#if TRAX_MOVE
- (void)showEventWithUid:(NSInteger)uid;

- (IBAction)showCalendar:(id)sender;
- (IBAction)showEventsList:(id)sender;

- (IBAction)showFavorites:(id)sender;
- (IBAction)showMap:(id)sender;
- (IBAction)showNews:(id)sender;
- (IBAction)showRecomendations:(id)sender;
- (IBAction)showUserProfile:(id)sender;

#elif TRAX_PREMIUM
- (IBAction)showDashboard:(id)sender;
//- (IBAction)showMap:(id)sender;
#endif

- (IBAction)showSearch:(id)sender;
- (IBAction)showTutorial:(id)sender;

- (IBAction)searchButtonTouched:(id)sender;

- (UIScrollView *)dataScrollView;

- (__kindof UITabBarController *)tabBarController;

@end

@interface UIViewController (ImpmelentedInTargets)

/**
 *  Name for storyboard file where this controller defined
 */
+ (NSString *)storyboardName;

@end
