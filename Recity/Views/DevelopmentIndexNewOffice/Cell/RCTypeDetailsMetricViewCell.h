//
//  RCTypeDetailsMetricViewCell.h
//  Recity
//
//  Created by Artem Kulagin on 23.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "BaseViewWithXIBInit.h"
#import "RCIndexUtils.h"

@interface RCTypeDetailsMetricViewCell : BaseViewWithXIBInit

@property (nonatomic) IBInspectable NSString *title;
@property (nonatomic) IBInspectable UIColor *color;

- (void)prepareValue:(NSNumber *)metric maxMetric:(NSNumber *)maxMetric suffix:(NSString *)suffix type:(RCGroupType)type;

- (void)prepareTitle:(NSString *)title;

+ (CGFloat)heightDefault;

@end
