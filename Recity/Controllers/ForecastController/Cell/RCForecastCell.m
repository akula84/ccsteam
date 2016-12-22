//
//  RCForecastCell.m
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastCell.h"

#import "RCProject.h"
#import "CGRect+Utils.h"

static CGFloat defaultHeightCell = 180.f;

@interface RCForecastCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation RCForecastCell

+ (CGFloat)widthWith:(RCProject *)item estimateFloor:(NSNumber *)estimateFloor heightCell:(CGFloat)heightCell
{
    UIImage *image = [self imageWith:item estimateFloor:estimateFloor];
    CGSize size = [RCForecastCell resizeSize:image.size heightCell:heightCell];
    return size.width + 45.f;
}

+ (CGSize)resizeSize:(CGSize)size heightCell:(CGFloat)heightCell
{
    CGFloat width = [self resizeValue:size.width heightCell:heightCell];
    CGFloat height = [self resizeValue:size.height heightCell:heightCell];
    return CGSizeMake(width, height);
}

+ (CGFloat)resizeValue:(CGFloat)value heightCell:(CGFloat)heightCell
{
    return value * heightCell/defaultHeightCell;
}

+ (UIImage *)imageWith:(RCProject *)item estimateFloor:(NSNumber *)estimateFloor
{
    NSNumber *floorCount = item.floorCount;
    NSUInteger count = floorCount.unsignedIntegerValue;
    if (!floorCount.isFull) {
        count = estimateFloor.unsignedIntegerValue;
    }
    NSArray *array;
    if (count <= 5) {
        array = [self arrRiseLow];
    }else if((6 <= count)&&(count <= 10)) {
        array = [self arrRiseMid];
    } if((11 <= count)&&(count <= 30)) {
        array = [self arrRiseHigh];
    } if(31 <= count) {
        array = [self arrRiseSky];
    }
    
    NSUInteger index = item.uid.unsignedIntegerValue % array.count;
    return IMG(array[index]);
}

- (void)setItem:(RCProject *)item estimateFloor:(NSNumber *)estimateFloor
{
    UIImage *image = [RCForecastCell imageWith:item estimateFloor:estimateFloor];
    UIImageView *imageView = self.imageView;
    CGSize size = [RCForecastCell resizeSize:image.size heightCell:CGRectGetHeight(self.frame)];
    self.widthImage.constant = size.width;
    self.heightImage.constant = size.height;
    [imageView setImage:image];
}

- (void)updateHeightWithOffset:(CGPoint)offset
{
    CGFloat positionCell = [self positionCellWithOffset:offset];
    [self prepareConstrainWithPositionCell:positionCell];
}

- (CGFloat)percentWithOffset:(CGPoint)offset
{
    CGRect cellFrame = self.frame;
    CGFloat width = self.widthScreen;
    
    CGFloat positionCell = CGRectGetMidX(cellFrame) - offset.x;
    CGFloat percent = 0.f;
    
    CGFloat correctionPositionCell = positionCell - width / 2;
    CGFloat cleanPercent = correctionPositionCell / (width / 2);
    percent = cleanPercent;
    
    return percent > 0.f ? percent : 0.f;
}

- (CGFloat)positionCellWithOffset:(CGPoint)offset
{
    CGRect cellFrame = self.frame;
    return CGRectGetMidX(cellFrame) - offset.x;
}

- (void)prepareConstrainWithPositionCell:(CGFloat)positionCell
{
    self.bottomConstraint.constant = [self bottomConstraintConstantWithPositionCell:positionCell];
}

- (void)prepareConstraint:(CGFloat)percent
{
    self.bottomConstraint.constant = [self bottomConstraintConstantWithPercent:percent];
}

- (CGFloat)bottomConstraintConstantWithPercent:(CGFloat)percent
{
    return 8 - CGRectGetHeight(self.imageView.frame) * percent * percent;
}

- (CGFloat)bottomConstraintConstantWithPositionCell:(CGFloat)positionCell
{
    CGFloat result = 0.f;
    CGFloat width = self.widthScreen;
    CGFloat heightImageView = CGRectGetHeight(self.imageView.frame);
    if(positionCell >= width) {
        result = 8.f - heightImageView;
    } else if(positionCell >= 0.85 * width && positionCell < width) {
        result = ((width - positionCell) / (0.15f * width)) * (0.3f * heightImageView - 2.4f) + 8.f - heightImageView;
    } else if(positionCell >= width / 2 && positionCell < 0.85 * width) {
        CGFloat a = (2.4f + 0.7f * heightImageView) / (0.85f * width * 0.85f * width + (width / 2.f) * (width / 2.f) - 0.85f * width * width);
        CGFloat b = -1.7f * a * width;
        CGFloat c = 8.f - a * (width / 2) * (width / 2) + 0.85f * a * width * width;
        result = a * positionCell * positionCell + b * positionCell + c;
    } else if(positionCell < width / 2) {
        result = 8;
    }
    return result;
}

+ (NSArray *)arrRiseLow
{
    return @[@"riseLow1",
             @"riseLow2",
             @"riseLow3",
             @"riseLow4",
             @"riseLow5",
             @"riseLow6",
             @"riseLow7",
             @"riseLow8",
             @"riseLow9",
             @"riseLow10",
             @"riseLow11"];
}

+ (NSArray *)arrRiseMid
{
    return @[@"riseMid1",
             @"riseMid2",
             @"riseMid3",
             @"riseMid4",
             @"riseMid5",
             @"riseMid6",
             @"riseMid7",
             @"riseMid8",
             @"riseMid9",
             @"riseMid10",
             @"riseMid11"];
}

+ (NSArray *)arrRiseHigh
{
    return @[@"riseHigh1",
             @"riseHigh2",
             @"riseHigh3",
             @"riseHigh4",
             @"riseHigh5",
             @"riseHigh6",
             @"riseHigh7"];
}

+ (NSArray *)arrRiseSky
{
    return @[@"riseSky1",
             @"riseSky2",
             @"riseSky3",
             @"riseSky4",
             @"riseSky5",
             @"riseSky6",
             @"riseSky7"];
}

- (CGFloat)widthScreen
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (void)setCenterAlfa:(BOOL)center
{
    self.imageView.alpha = center?1.0f:0.5f;
}

@end
