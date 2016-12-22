//
//  RCForecastViewController+Anumation.m
//  Recity
//
//  Created by Artem Kulagin on 06.07.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCForecastViewController_Private.h"

static CGFloat const durationAnimation = 1.f;
static CGFloat const durationCard = 0.375f;

@implementation RCForecastViewController (Animation)

- (void)startChangeProject:(CGPoint)contentOffset animated:(BOOL)animated
{   
    [self animationBuildingViewWithContentOffset:contentOffset
                                        animated:animated];
    [self reloadTop];
    [self animationCardView:animated];
}

- (void)animationBuildingViewWithContentOffset:(CGPoint)contentOffset
                                      animated:(BOOL)animated
{
    if(animated) {
        CGFloat duration = durationAnimation;
        
        CGPoint currentContentOffset = self.collectionView.contentOffset;
        NSTimeInterval currentDuration = duration / (60 * duration);
        NSTimeInterval currentDelay = 0.f;
        CGPoint differenceContentOffset = CGPointMake(contentOffset.x - currentContentOffset.x,
                                                      contentOffset.y - currentContentOffset.y);
        CGPoint stepContentOffset = CGPointMake(differenceContentOffset.x / (60 * duration),
                                                differenceContentOffset.y / (60 * duration));
        for(NSUInteger i = 0; i < 60 * duration; i++) {
            currentDelay = i * currentDuration;
            currentContentOffset = CGPointMake(currentContentOffset.x + stepContentOffset.x,
                                               currentContentOffset.y + stepContentOffset.y);
            
            [UIView animateWithDuration:currentDuration
                                  delay:currentDelay
                                options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionNone
                             animations:^{
                                 self.collectionView.contentOffset = currentContentOffset;
                                 [self.collectionView layoutIfNeeded];
                                 [self updateCellHeightImageWithNewContentOffset:currentContentOffset];
                             }
                             completion:NULL];
        }
        
        [UIView animateWithDuration:duration
                         animations:^{
                             [self updateCellsAlfaCenter];
                             [self updateImageBackground];
                         }];
        
    } else {
        self.collectionView.contentOffset = contentOffset;
        [self.collectionView layoutIfNeeded];
        [self updateCells];
        [self updateImageBackground];
    }
}

- (void)animationCardView:(BOOL)animated
{
    if (!animated) {
        [self reloadCard];
        return;
    }
    
    [UIView animateWithDuration:durationCard animations:^{
        [self cardHidden:YES];
    } completion:^(BOOL finished) {
        [self reloadCard];
    }];
    
    NSTimeInterval delay = durationAnimation - durationCard;
    [UIView animateWithDuration:durationCard
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionNone)
                     animations:^{
        [self cardHidden:NO];
    } completion:nil];
}


@end
