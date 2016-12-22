//
//  UIColor+RCScheme.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 12.05.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor * MGRColorRGB(CGFloat r, CGFloat g, CGFloat b);
UIColor * MGRColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
UIColor * MGRColorWithHex(NSString *hexString);

@interface UIColor (RCScheme)


@end
