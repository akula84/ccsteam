//
//  BaseViewController.h
//  golf-fitness
//
//  Created by Matveev on 03.02.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTableCell;

@interface RCBaseViewController : UIViewController

@property (copy, nonatomic) NSString *concretizedTitle;

@property (strong, nonatomic) dispatch_block_t actionsAfterFirstViewWillAppearBlock;
@property (strong, nonatomic) dispatch_block_t actionsAfterFirstDidLoadSubviewsBlock;

//- (void)addGrayNetBackgroundToView:(UIView *)view;
//- (void)addBackButton;
//- (void)addMenuButton;

@end
