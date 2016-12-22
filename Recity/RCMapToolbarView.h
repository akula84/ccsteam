//
//  RCMapToolbarView.h
//  Recity
//
//  Created by Matveev on 04/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCToolbarView.h"

typedef NS_ENUM(NSInteger, RCMapToolbarViewState) {
    RCMapToolbarViewStateNormal = 0,
    RCMapToolbarViewStateDetails = 1
};

typedef void (^RCToolbarViewItemBlock) (NSInteger toolbarViewItemIndex, BOOL selectedItemPressed);

@interface RCMapToolbarView : RCToolbarView

@property (assign, nonatomic) RCMapToolbarViewState state;

@property (strong, nonatomic) RCToolbarViewItemBlock didToolbarViewItemSelectedBlock;

- (void)switchStateToNormal;
- (void)switchStateToProjectDetails;

@end
