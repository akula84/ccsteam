//
//  RCToolbarView+Protected.h
//  Recity
//
//  Created by ezaji.dm on 29.08.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCToolbarView.h"

@interface RCToolbarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *selectedIndexPathsBeforeSelection;
@property (strong, nonatomic) NSIndexPath *previousItemIndexPath;

@end
