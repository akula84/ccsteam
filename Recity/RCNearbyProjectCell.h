//
//  RCNearbyProjectCell.h
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"

@interface RCNearbyProjectCell : RCBaseSeparatedTableCell

@property (strong, nonatomic) RCProject *project;
@property (strong, nonatomic) DidPressedProjectImageBlock didPressedProjectImageBlock;

@end
