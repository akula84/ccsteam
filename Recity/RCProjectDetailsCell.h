//
//  RCProjectDetailsCell.h
//  Recity
//
//  Created by Matveev on 21/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"
#import "RCProjectDetail.h"

@class RCProjectDetailsCell;

@interface RCProjectDetailsCell : RCBaseSeparatedTableCell

@property (strong, nonatomic) RCProjectDetail *detail;

@end
