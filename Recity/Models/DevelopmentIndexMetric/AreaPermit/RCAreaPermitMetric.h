//
//  RCAreaPermitMetric.h
//  Recity
//
//  Created by Artem Kulagin on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexMetricModel.h"

@interface RCAreaPermitMetric : RCDevelopmentIndexMetricModel

@property (copy, nonatomic) void (^update)(void);

@property (strong, nonatomic) NSNumber *oneAgo;
@property (strong, nonatomic) NSNumber *twoAgo;
@property (strong, nonatomic) NSNumber *threeAgo;

@property (assign, nonatomic) BOOL hideUp;
@property (assign, nonatomic) BOOL hideDown;

@end
