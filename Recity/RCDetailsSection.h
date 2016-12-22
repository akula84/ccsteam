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
    DetailsSectionTypeUpcomingTenants = 1,
    DetailsSectionTypeNotes = 2,
    DetailsSectionTypeDevelopmentIndex = 3,
    DetailsSectionTypeNearbyDevelopments = 4
};

@interface RCDetailsSection : RCTableSection

@property (assign, nonatomic) DetailsSectionType type;

@end
