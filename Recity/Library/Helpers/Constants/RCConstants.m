//
//  RCConstants.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 07.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCConstants.h"

const CGFloat kKeyBoardAnimation = 0.2f,
kCellInsets = 26.f;

NSString *const kPlanned = @"Planned",
*const kUnderConstruction = @"UnderConstruction",
*const kUnannounced = @"Unannounced",
*const kCompleted = @"Completed",
*const kStatus = @"status",
*const kUid = @"uid",
*const kId = @"id",
*const kUpcomingtenants = @"Upcoming Tenants",
*const kNearbyDevelopments = @"NearbyDevelopments",
*const kTypeDetails = @"typeDetails",
*const kApartments = @"apartments",
*const kCondominiums = @"condominiums",
*const kResidentialTbd = @"residentialTbd",
*const kOffice = @"office",
*const kRetail = @"retail",
*const kHotel = @"hotel",
*const kEntertainment = @"entertainment",
*const kOther = @"otherType",
*const kTBD = @"TBD",

//Suggest
*const kProjectId = @"projectId",
*const kSuggestionType = @"suggestionType",
*const kStatusSuggestion = @"statusSuggestion",
*const kCompletionDate = @"completionDate",
*const kFloorCount = @"floorCount",
*const kTenantsSuggestion = @"tenantSuggestions",
*const kTextOtherSuggestion = @"otherSuggestion",

// API
*const kLogin = @"username",
*const kPassword = @"password",
*const kGrant_type  = @"grant_type",

//Contact Us
*const kContactUsMessage = @"message",
*const kContactUsReason = @"reason",

//Share Coordinate
*const kLatitude = @"latitude",
*const kLongitude = @"longitude",

// API URLs
//*const kAPIBaseURL = @"http://recity-dev.azurewebsites.net/api/",
*const kAPIBaseURL = @"http://recity-staging2.azurewebsites.net/api/",
*const kAPIGetProjects = @"projects",
*const kAPIGetProjectsDeletedids = @"projects/deletedids",
*const kAPIPostSignIn = @"token",
*const kAPIGetCities = @"cities",
*const kAPIGetUserData = @"user/data",
*const kAPIGetGeoCoordinateChangeScore = @"changescore",
*const kAPISearch = @"search",
*const kAddFavorite = @"user/favorite",
*const kAPIRemoveFavorite = @"user/favorite",
*const kAPIProfile = @"user/profile",
*const kAPIAddress = @"reverseGeocode",
*const kAPIPostSuggestion = @"projects/suggestion",
*const kAPIAddUserNotes = @"user/note",
*const kAPIContactUs = @"contact",
*const kAPIShareCoordinateUrl = @"sharecoordinateurl",

//Notifications
*const kNotificationProjectsLoaded = @"notificationProjectsLoaded",
*const kNotificationMetricsCellNeedReload = @"notificationMetricsCellNeedReload",
*const kNotificationCurrentDevelopmentIndexUpdated = @"notificationCurrentDevelopmentIndexUpdated"
;

//Numbers
const NSUInteger kZoomLevelMaxForProjectOverlays = 16
;
