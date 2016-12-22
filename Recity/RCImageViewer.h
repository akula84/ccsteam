//
//  RCImageViewer.h
//  Recity
//
//  Created by Matveev on 21/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCImageViewer : NSObject

- (void)presentInVC:(UIViewController *)vc imagesOrUrls:(NSArray *)imagesOrUrls;
- (void)pushInNavigationVC:(UINavigationController *)nc imagesOrUrls:(NSArray *)imagesOrUrls;

@end
