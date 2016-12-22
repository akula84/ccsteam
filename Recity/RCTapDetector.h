//
//  RCTapDetector.h
//  Recity
//
//  Created by Matveev on 16/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTapDetector : NSObject

@property (copy, nonatomic) dispatch_block_t didTappedBlock;

- (void)attachToTargetView:(UIView *)targetView;

@end
