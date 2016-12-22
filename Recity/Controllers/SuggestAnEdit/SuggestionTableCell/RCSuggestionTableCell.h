//
//  RCSuggestionTableCell.h
//  Recity
//
//  Created by ezaji.dm on 11.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCBaseSeparatedTableCell.h"

#import "RCSuggestionViewModel.h"

typedef void (^RCDidPressedCellBlock)();

@interface RCSuggestionTableCell : RCBaseSeparatedTableCell

@property (strong, nonatomic) RCSuggestionViewModel *model;

@property (copy, nonatomic) RCDidPressedCellBlock didPressedCellBlock;

@end
