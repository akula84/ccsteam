//
//  RCTutorialSinglePageViewController.h
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseViewController.h"

@class RCTutorialPageModel;

@interface RCTutorialSinglePageViewController : RCBaseViewController

@property (strong, nonatomic, readonly) RCTutorialPageModel *model;

+ (instancetype)pageWithModel:(RCTutorialPageModel *)model;

@end
