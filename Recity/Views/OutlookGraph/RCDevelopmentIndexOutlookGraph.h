//
//  RCDevelopmentIndexOutlookGraph.h
//  Recity
//
//  Created by Vitaliy Zhukov on 22.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

typedef NS_ENUM(NSInteger, RCDIOutlookGraphType) {
    RCDIOutlookGraphTypeLow = 1,
    RCDIOutlookGraphTypeModerateShortTerm = 2,
    RCDIOutlookGraphTypeModerateLongTerm = 3,
    RCDIOutlookGraphTypeSteady = 4,
    RCDIOutlookGraphTypeStrongShortTerm = 5,
    RCDIOutlookGraphTypeStrongLongTerm = 6,
    RCDIOutlookGraphTypeVeryStrong = 7
};

@interface RCDevelopmentIndexOutlookGraph : UIView

- (void)setGraphType:(RCDIOutlookGraphType)type;

@end
