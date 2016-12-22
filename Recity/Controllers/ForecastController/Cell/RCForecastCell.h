//
//  RCForecastCell.h
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCProject;

@interface RCForecastCell : UICollectionViewCell

- (void)setCenterAlfa:(BOOL)center;
- (void)setItem:(RCProject *)item estimateFloor:(NSNumber *)estimateFloor;
- (void)updateHeightWithOffset:(CGPoint)offset;
+ (CGFloat)widthWith:(RCProject *)item estimateFloor:(NSNumber *)estimateFloor heightCell:(CGFloat)heightCell;

@end
