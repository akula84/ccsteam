//
//  RCRCProjectTenantCell.h
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"

@class RCProjectDetail;

@interface RCProjectTenantCell : RCBaseSeparatedTableCell

@property (strong, nonatomic) RCProjectDetail *detail;
@end
