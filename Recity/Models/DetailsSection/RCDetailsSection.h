//
//  RCDetailsSection.h
//  Recity
//
//  Created by Matveev on 27/04/16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCTableSection.h"

typedef NS_ENUM(NSInteger, DetailsSectionType) {
    DetailsSectionTypeDevelopmentDetails = 0,
    DetailsSectionTypeSuggestAnEdit = 1,
    DetailsSectionTypeUpcomingTenants = 2,
    DetailsSectionTypeNotes = 3,
    DetailsSectionTypeDevelopmentIndex = 4,
    DetailsSectionTypeNearbyDevelopments = 5
};

@interface RCDetailsSection : RCTableSection

@property (assign, nonatomic) DetailsSectionType type;

@end
