//
//  RCDevelopmentIndexMetricModel.h
//  Recity
//
//  Created by Vitaliy Zhukov on 21.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "PureLayout.h"

static NSString * kNotEnough = @"Not enough data available";

@class RCAddress;

@interface RCDevelopmentIndexMetricModel : NSObject

@property (weak, nonatomic) RCAddress *address;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descriptionTitle;
@property (nonatomic) BOOL opened;
@property (nonatomic) BOOL enabled;

- (void)loadData;
- (UIView *)viewForMetric;
- (CGFloat)heightForView;

+ (instancetype)modelWithTitle:(NSString *)title;

@end
