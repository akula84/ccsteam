//
//  RCAreaPermitCell.h
//  Recity
//
//  Created by Artem Kulagin on 24.06.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "BaseViewWithXIBInit.h"

@interface RCAreaPermitCell : BaseViewWithXIBInit

- (void)setPercent:(NSNumber *)percent maxValue:(NSNumber *)maxValue;
- (void)hideUp;
- (void)hideDown;

@end
