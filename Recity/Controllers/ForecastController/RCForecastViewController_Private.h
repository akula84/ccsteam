//
//  RCForecastViewController+CollectionView.h
//  Recity
//
//  Created by Artem Kulagin on 04.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

@class RCProject;

#import "RCForecastViewController.h"

@interface RCForecastViewController ()

@property (strong, nonatomic) NSArray *projects;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *forwardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *forwardView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIImageView *countImage;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *cardViews;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UIImageView *additionalImageBackground;

@property (assign, nonatomic) CGFloat minOffset;
@property (assign, nonatomic) CGFloat maxOffset;
@property (assign, nonatomic) BOOL firstRunCompleted;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCollectionConstraint;

- (CGFloat)widthScreenHalf;
- (CGFloat)widthScreen;
- (CGSize)screenSize;
- (RCProject *)currentProject;
- (NSNumber *)estimateFloor;

@end

@interface RCForecastViewController (CollectionView) <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)nextCell;
- (void)backCell;
- (void)setIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)currentIndexPath;
- (void)updateCells;
- (void)updateCellsAlfaCenter;
- (void)updateCellHeightImageWithNewContentOffset:(CGPoint)contentOffset;
- (void)prepareContentInset;
- (void)prepareHeightCollectionView;

@end

@interface RCForecastViewController (Action)

@end

@interface RCForecastViewController (Animation)

- (void)startChangeProject:(CGPoint)contentOffset animated:(BOOL)animated;

@end

@interface RCForecastViewController (ReloadViews)

- (void)reloadTop;
- (void)reloadCard;
- (void)cardHidden:(BOOL)hidden;
- (void)prepareNoData;
- (void)updateImageBackground;

@end

@interface RCForecastViewController (ScrollDelegate)

- (void)calculateMaxMinOffset;

@end
