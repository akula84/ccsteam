//
//  RCSegmentedProcentageSelector.h
//  Recity
//
//  Created by Vitaliy Zhukov on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "BaseViewWithXIBInit.h"

@protocol RCSegmentedProcentageSelectorDelegate <NSObject>
@required

- (void)segmentedSelectorDidSelectSegmentAtIndex:(NSUInteger)index;

@end

@interface RCSegmentedProcentageSelector : BaseViewWithXIBInit

@property (strong, nonatomic) NSArray <NSNumber *> *values;
@property (strong, nonatomic) UIColor *selectionColor;
@property (strong, nonatomic) id <RCSegmentedProcentageSelectorDelegate> delegate;
@property (nonatomic) NSUInteger selectedIndex;

@end
