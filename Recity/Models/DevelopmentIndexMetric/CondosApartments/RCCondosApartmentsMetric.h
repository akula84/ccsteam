//
//  RCCondosApartmentsMetric.h
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCDevelopmentIndexMetricModel.h"

@interface RCCondosApartmentsMetric : RCDevelopmentIndexMetricModel

@property (strong, nonatomic) NSNumber *condosTotal;
@property (strong, nonatomic) NSNumber *aptsTotal;
@property (strong, nonatomic) NSNumber *projectTbd;

@property (strong, nonatomic) NSNumber *condosComplete;
@property (strong, nonatomic) NSNumber *aptsComplete;

@property (strong, nonatomic) NSNumber *condosUpcoming;
@property (strong, nonatomic) NSNumber *aptsUpcoming;

@end
