//
//  RCMapViewController+AnimationSearch.m
//  Recity
//
//  Created by Artem Kulagin on 31.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCMapViewController_Private.h"

#import "CGRect+Utils.h"
#import "NMBNavigationBarWithAddedHeight.h"
#import "UIColor+RCColor.h"

@implementation RCMapViewController (SearchNav)

- (void)moveLeftTitleBar
{
    UILabel *animateLabel = [self createAnimateTitle];
    [self prepareClearTitle];
    [self moveLabelLeft:animateLabel];
}

- (void)moveLabelLeft:(UILabel *)label
{
    CGFloat widthText = [self widthText:label];
    UIView *coverView = [self createCoverView];
    [self addSearchTextField];
    [UIView animateWithDuration:0.1f animations:^{
        label.center = CGPointMake(offsetXCursor - widthText/2.f, label.center.y);
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [coverView removeFromSuperview];
    }];
}

- (CGFloat)widthText:(UILabel *)label
{
    return [label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName:label.font } context:nil].size.width;
}

- (UILabel *)createAnimateTitle
{
    UINavigationBar *navigationBar = [self navigationBar];
    CGRect bounds = [self boundsNavigationBar];
    bounds = CGRectSetHeight(bounds,CGRectGetHeight(bounds) + 4.f);
    UILabel *label = [[UILabel alloc]initWithFrame:bounds];
    label.font = [self fontTitleBar];
    label.textColor = [UIColor purpleRCColor];
    label.text = self.title;
    label.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:label];
    return label;
}

- (UIView *)createCoverView
{
    CGRect bounds = [self boundsNavigationBar];
    UINavigationBar *navigationBar = [self navigationBar];
    bounds = CGRectSetWidth(bounds, offsetXCursor);
    UIView *view = [[UIView alloc]initWithFrame:bounds];
    view.backgroundColor =  [UIColor whiteColor];
    [navigationBar addSubview:view];
    UIImage *image = [UIImage imageNamed:@"back"];
    CGSize size = image.size;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16.f, 19.f, size.width, size.height)];
    [imageView setImage:image];
    [view addSubview:imageView ];
     return view;
}

- (CGRect)boundsNavigationBar
{
    NMBNavigationBarWithAddedHeight *navigationBar = (NMBNavigationBarWithAddedHeight *)[self navigationBar];
    CGRect bounds = navigationBar.bounds;
    return  CGRectSetHeight(bounds,CGRectGetHeight(bounds) + navigationBar.addedHeight);
}

- (UIFont *)fontTitleBar
{
    NSDictionary *titleTextAttributes = [self titleTextAttributes];
    return [titleTextAttributes objectForKey:NSFontAttributeName];
}

- (UIColor *)colorTitleBar
{
    NSDictionary *titleTextAttributes = [self titleTextAttributes];
    return [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
}

- (NSDictionary *)titleTextAttributes
{
    UINavigationBar *navigationBar = [self navigationBar];
    return navigationBar.titleTextAttributes;
}

- (UINavigationBar *)navigationBar
{
    return self.navigationController.navigationBar;
}

@end
