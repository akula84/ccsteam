//
//  RCProjectDetailsCell.h
//  Recity
//
//  Created by Matveev on 21/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"
//#import "RCProjectDetail.h"

@class RCProjectDetail;

@interface RCProjectDetailsCell : RCBaseSeparatedTableCell

@property (strong, nonatomic) RCProjectDetail *detail;

+ (CGFloat)height:(RCProjectDetail *)detail;

@end
