//
//  UICollectionViewCell+More.h
//  golf-fitness
//
//  Created by Matveev on 11.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (More)

+ (void)registerInCollectionView:(UICollectionView *)collectionView;
+ (id)createForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
