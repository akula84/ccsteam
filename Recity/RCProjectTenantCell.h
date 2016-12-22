//
//  RCRCProjectTenantCell.h
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"
#import "RCProjectDetail.h"

@interface RCProjectTenantCell : RCBaseSeparatedTableCell

@property (strong, nonatomic) RCProjectDetail *detail;
@end
