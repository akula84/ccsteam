//
//  RCProjectDetailsTableManager.h
//  Recity
//
//  Created by Matveev on 26/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTableManager.h"
#import "RCDetailsSection.h"

@interface RCProjectDetailsTableManager : RCTableManager

@property (copy, nonatomic) DidPressedProjectImageBlock didPressedProjectImageBlock;
@property (copy, nonatomic) void(^checkVisibleSectionType)(DetailsSectionType visibleSectionType);

- (void)scrollToSectionWithTypeIfExists:(DetailsSectionType)sectionType
                               animated:(BOOL)animated;
/*
 * Animated default is YES;
 */
- (void)scrollToSectionWithTypeIfExists:(DetailsSectionType)sectionType;

@end
