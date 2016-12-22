//
//  UICollectionViewCell+More.m
//  golf-fitness
//
//  Created by Matveev on 11.03.16.
//  Copyright © 2016 Magora Systems. All rights reserved.
//

#import "UICollectionViewCell+More.h"



@implementation UICollectionViewCell (More)

+ (void)registerInCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:[self rc_className] bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[self rc_className]];
}

+ (id)createForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *result;
    result = [collectionView dequeueReusableCellWithReuseIdentifier:[self rc_className] forIndexPath:indexPath];
    return result;
}

@end
