//
//  RCTutorialManager.h
//  Recity
//
//  Created by Vitaliy Zhukov on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "NSObject+SingletonObject.h"

#import "RCMapViewController_Private.h"

@class RCTutorialPageModel;

@interface RCTutorialManager : NSObject

@property (nonatomic, readonly) NSUInteger pagesCount;
@property (nonatomic) NSUInteger currentPageIndex;

- (void)setCurrentModel:(RCTutorialPageModel *)model;

- (RCTutorialPageModel *)currentPage;
- (RCTutorialPageModel *)nextPage;
- (RCTutorialPageModel *)previousPage;

- (void)saveState;
- (void)resetState;

@end

@interface RCTutorialManager (Show)

+ (void)beginTutorial;
+ (void)beginTutorialIfNeeded;

@end
