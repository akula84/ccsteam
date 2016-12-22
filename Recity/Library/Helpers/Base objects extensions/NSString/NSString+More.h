//
//  NSString+More.h
//  Recity
//
//  Created by Matveev on 25/05/16.
//  Copyright © 2016 Recity. All rights reserved.
//

@interface NSString (More)

- (NSAttributedString *)stringWithSpacing:(CGFloat)spacing;
- (CGFloat)widthWithFont:(UIFont *)font height:(CGFloat)height;
- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;

@end
