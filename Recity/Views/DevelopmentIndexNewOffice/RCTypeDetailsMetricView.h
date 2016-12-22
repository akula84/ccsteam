//
//  RCNewOfficeView.h
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "BaseViewWithXIBInit.h"

#import "RCIndexUtils.h"

@class RCTypeDetailsMetric;

@interface RCTypeDetailsMetricView : BaseViewWithXIBInit

- (void)setModel:(RCTypeDetailsMetric *)model type:(RCGroupType)type;

@end
