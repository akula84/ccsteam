//
//  RCNewOfficeMetric.h
//  Recity
//
//  Created by Artem Kulagin on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexMetricModel.h"

@interface RCTypeDetailsMetric : RCDevelopmentIndexMetricModel

@property (strong, nonatomic) NSNumber *planned;
@property (strong, nonatomic) NSNumber *under;
@property (strong, nonatomic) NSNumber *completed;

- (NSString *)suffixCount;

@end
