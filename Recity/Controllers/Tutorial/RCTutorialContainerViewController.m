//
//  RCTutorialViewController.m
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTutorialContainerViewController.h"

#import "RCTutorialSinglePageViewController.h"
#import "RCTutorialManager.h"
#import "RCTutorialPageModel.h"
#import "FXPageControl.h"
#import "JMHoledView.h"

@interface RCTutorialContainerViewController() <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;

@property (strong, nonatomic) IBOutlet JMHoledView *holedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalPositionConstraint;

@end

@implementation RCTutorialContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self preparePager];
    
    [self updateCurrentPageAnimated:NO backward:NO];
}

- (void)preparePager
{
    UIPageViewController *pageViewController = [self.childViewControllers firstObject];
    
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    
    self.pageControl.numberOfPages = (NSInteger)self.manager.pagesCount;
}

- (IBAction)closeAction:(id)sender
{
    self.manager.currentPageIndex = 0;
    [self.manager resetState];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonAction:(id)sender
{
    self.manager.currentPageIndex--;
    [self updateCurrentPageAnimated:YES backward:YES];
}

- (IBAction)forwardButtonAction:(id)sender
{
    self.manager.currentPageIndex++;
    [self updateCurrentPageAnimated:YES backward:NO];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    RCTutorialPageModel *model = [self.manager previousPage];
    UIViewController *result = nil;
    
    if (model) {
        result = [RCTutorialSinglePageViewController pageWithModel:model];
    }
    
    return result;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    RCTutorialPageModel *model = [self.manager nextPage];
    UIViewController *result = nil;
    
    if (model) {
        result = [RCTutorialSinglePageViewController pageWithModel:model];
    }
    
    return result;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray <UIViewController *> *)pendingViewControllers
{
    RCTutorialSinglePageViewController *controller = (RCTutorialSinglePageViewController *)[pendingViewControllers firstObject];
    [self.manager setCurrentModel:controller.model];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self updateUI];
    }
}

- (IBAction)pageControlSelectPage:(FXPageControl *)sender
{
    NSUInteger currentIndex = self.manager.currentPageIndex;
    NSUInteger newIndex = (NSUInteger)sender.currentPage;
    
    if (newIndex != currentIndex) {
        [self.manager setCurrentPageIndex:(NSUInteger)sender.currentPage];
        [self updateCurrentPageAnimated:YES backward:(newIndex < currentIndex)];
    }
}

- (void)updateCurrentPageAnimated:(BOOL)animated backward:(BOOL)backward
{
    UIPageViewControllerNavigationDirection direction = backward ? UIPageViewControllerNavigationDirectionReverse :
                                                                    UIPageViewControllerNavigationDirectionForward;
    
    RCTutorialPageModel *model = [self.manager currentPage];
    
    RCTutorialSinglePageViewController *page = [RCTutorialSinglePageViewController pageWithModel:model];
    
    UIPageViewController *pageViewController = [self.childViewControllers firstObject];
    
    [pageViewController setViewControllers:@[page] direction:direction animated:animated completion:^(BOOL finished) {}];
    
    [self updateUI];
}

- (void)updateUI
{
    [self performUserAction];
    [self updatePageControl];
    [self updateButtons];
    [self updateDialogueHeight];
    [self updateHoles];
}

- (void)performUserAction
{
    RCTutorialPageModel *model = [self.manager currentPage];
    RUN_BLOCK(model.selectionAction);
}

- (void)updateDialogueHeight
{
    RCTutorialPageModel *model = self.manager.currentPage;
    
    self.verticalPositionConstraint.constant = model.moveUp ? 246.0f : 70.0f;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateButtons
{
    self.backButton.hidden = [self.manager previousPage] == nil;
    self.forwardButton.hidden = [self.manager nextPage] == nil;
    self.doneButton.hidden = [self.manager nextPage] != nil;
}

- (void)updatePageControl
{
    self.pageControl.currentPage = (NSInteger)self.manager.currentPageIndex;
}

- (void)updateHoles
{
    JMHoledView *view = self.holedView;
    RCTutorialPageModel *model = self.manager.currentPage;
    
    [view removeHoles];
    
    for (NSValue *rectValue in model.viewHoleFrames) {
        CGRect rect = [rectValue CGRectValue];
        [view addHoleRectOnRect:rect];
    }
}

- (RCTutorialManager *)manager
{
    return [RCTutorialManager shared];
}

@end
