//
//  RCPlannedTimeline.h
//  Recity
//
//  Created by Artem Kulagin on 28.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "BaseViewWithXIBInit.h"

@class RCPlannedTimelineMetric;

@interface RCPlannedTimelineView : BaseViewWithXIBInit

- (void)setModel:(RCPlannedTimelineMetric *)model;

@end
