//
//  RCUser.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 11.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCUser.h"
#import "RCUserInfo.h"
#import "RCProject.h"
#import "RCFavoritedProjectInfo.h"

@implementation RCUser

#pragma mark - Services

+ (PMKPromise *)authWithLogin:(NSString *)login password:(NSString *)password {
    PMKPromise *result = [[RCHTTPSessionManager shared] authWithLogin:login password:password];
    return result;
}

#pragma mark - Mappings

+ (EKManagedObjectMapping *)authMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass([self class]) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapKeyPath:@"authorizationToken" toProperty:@"authorizationToken" withValueBlock:^id(NSString *key, id value, NSManagedObjectContext *context) {
            
            return value;
        }];
        [mapping mapPropertiesFromDictionary:({
            @{
              @"userProfile.email" : @"login",
              @"userProfile.firstName" : @"firstName",
              @"userProfile.lastName" : @"lastName",
              @"userProfile.role" : @"role",
              };
        })];
        [mapping setPrimaryKey:@"login"];
    }];
}

- (PMKPromise *)setProject:(RCProject *)project favoritedRemotely:(BOOL)favorited {//       project will added or removed from favorited once
    __block PMKPromise *result;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectUID = %@",project.uid];
    NSArray *favoritedProjectInfosWithSameProjectUID = [[[AppState sharedInstance].user.userinfo.favoritedProjectInfos filteredSetUsingPredicate:predicate] allObjects];
    RCFavoritedProjectInfo *firstInfo = [favoritedProjectInfosWithSameProjectUID firstObject];

    if (favorited) {
        //      mark in DB this project as favorited. FavoriteUID will attached to RCFavoritedProjectInfo which created for this project when responce will be taken
        result = [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull backgroundContextWheretoSave) {
                RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:backgroundContextWheretoSave] firstObject];
                RCUserInfo *userInfo = (RCUserInfo *)localUser.userinfo;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectUID = %@",firstInfo.projectUID];
                NSArray *favoritedProjectInfosWithSameProjectUID = [[userInfo.favoritedProjectInfos filteredSetUsingPredicate:predicate] allObjects];
                if (favoritedProjectInfosWithSameProjectUID.count > 0) {
                    
                } else {
                    RCFavoritedProjectInfo *result = [RCFavoritedProjectInfo MR_createEntityInContext:backgroundContextWheretoSave];
                    result.projectUID = [project.uid copy];
                    [userInfo addFavoritedProjectInfosObject:result];
                }
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                RCBaseRequest *markFavorited = ({
                    RCBaseRequest *request = [RCBaseRequest new];
                    request.methodString = @"PUT";
                    request.methodName = @"AddFavorite";
                    request.mappedObjectForNonparceableObjectBlock = ^(id object, NSManagedObjectContext *backgroundContextWheretoSave) {
                        RCFavoritedProjectInfo *result;
                        RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:backgroundContextWheretoSave] firstObject];
                        RCUserInfo *userInfo = (RCUserInfo *)localUser.userinfo;
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectUID = %@",firstInfo.projectUID];
                        NSArray *favoritedProjectInfosWithSameProjectUID = [[userInfo.favoritedProjectInfos filteredSetUsingPredicate:predicate] allObjects];
                        if (favoritedProjectInfosWithSameProjectUID.count > 0) {
                            result = [favoritedProjectInfosWithSameProjectUID firstObject];
                            result.uid = [object copy];
                        }
                        return result;
                    };
                    request.parameters = ({
                        @{
                          @"projectId": project.uid,
                          };
                    });
                    request;
                });
                
                NSLog(@"AFTER ADD FAVORITE");
                [RCFavoritedProjectInfo rc_logFieldsOfAllInMainContext];
                [[NSNotificationCenter defaultCenter] postNotificationName:kProjectFavoriteChangedNotification object:project userInfo:nil];
                [[RCHTTPSessionManager shared] loadRequest:markFavorited].then(^(id mappedObject) {
                    RUN_BLOCK(resolve, mappedObject);
                });
            }];
        }];
    } else {
        if (firstInfo.uid) {
            //      delete RCFavoritedProjectInfo which created for this project from DB once
            result = [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull backgroundContextWheretoSave) {
                    //      there sometimes may be 2 or more RCFavoritedProjectInfo with same projectUID. For avoid of hard debugging remove all of them
                    RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:backgroundContextWheretoSave] firstObject];
                    RCUserInfo *userInfo = (RCUserInfo *)localUser.userinfo;
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectUID = %@",firstInfo.projectUID];
                    NSArray *favoritedProjectInfosWithSameProjectUID = [[userInfo.favoritedProjectInfos filteredSetUsingPredicate:predicate] allObjects];
                    for (RCFavoritedProjectInfo *currentProjectInfo in favoritedProjectInfosWithSameProjectUID) {
                        [currentProjectInfo MR_deleteEntityInContext:backgroundContextWheretoSave];
                    }
                } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    RCBaseRequest *markFavorited = ({
                        RCBaseRequest *request = [RCBaseRequest new];
                        request.methodString = @"DELETE";
                        request.methodName = [NSString stringWithFormat:@"RemoveFavorite?id=%@",firstInfo.uid];
                        request.objectMapping = nil;
                        request.parameters = nil;
                        request;
                    });
                    
                    NSLog(@"AFTER DELETE FAVORITE");
                    [RCFavoritedProjectInfo rc_logFieldsOfAllInMainContext];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kProjectFavoriteChangedNotification object:project userInfo:nil];
                    [[RCHTTPSessionManager shared] loadRequest:markFavorited].then(^(id mappedObject) {
                        RUN_BLOCK(resolve, mappedObject);
                    });
                }];
            }];
        } else {
            NSLog(@"BAD RCFavoritedProjectInfo uid %@",firstInfo);
        }
    }
    return result;
}

+ (EKManagedObjectMapping *)addFavoriteMapping {
    return [EKManagedObjectMapping mappingForEntityName:[RCFavoritedProjectInfo rc_className] withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping mapKeyPath:@"favoriteID" toProperty:@"favoriteUID"];
    }];
}

- (BOOL)isProjectFavoritedLocally:(RCProject *)project {
    BOOL result = NO;
    NSArray *favoritedProjectInfosWithSameProjectUID = [[[AppState sharedInstance].user.userinfo.favoritedProjectInfos filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"projectUID = %@",project.uid]] allObjects];
    if (favoritedProjectInfosWithSameProjectUID.count > 0) {
        RCFavoritedProjectInfo *firstFavoritedProjectInfo = [favoritedProjectInfosWithSameProjectUID firstObject];
        if (firstFavoritedProjectInfo.uid) {
            result = YES;
        }
    }
    return result;
}

- (NSArray *)locallyFavoritedProjects {
    NSArray *result = @[];
    if ([AppState sharedInstance].user.userinfo.favoritedProjectInfos) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid IN %@",[[AppState sharedInstance].user.userinfo.favoritedProjectInfos valueForKey:@"projectUID"]];
        NSLog(@"predicate %@",predicate);
        result = [RCProject MR_findAllWithPredicate:predicate];
    }
    return result;
}

- (PMKPromise *)downloadUserInfo {
    RCBaseRequest *downloadFavoritedProjectsWithNotesRequest = ({
        RCBaseRequest *request = [RCBaseRequest new];
        request.methodString = @"GET";
        request.methodName = @"GetUserData";
        request.parameters = nil;
        request.actionsBeforeMappingBlock = ^(id object, NSManagedObjectContext *backgroundContextWheretoSave) {
            RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:backgroundContextWheretoSave] firstObject];
            [localUser.userinfo MR_deleteEntityInContext:backgroundContextWheretoSave];//       cascase removes RCFavoritedObjectInfos
        };
        request.objectMapping = [RCUser downloadUserInfoMapping];
        request.actionsAfterMappingBlock = ^(id object, NSManagedObjectContext *backgroundContextWheretoSave) {
            RCUser *localUser = [[RCUser rc_objectsWithValues:@[[AppState sharedInstance].user.login] ofFieldName:@"login" inContext:backgroundContextWheretoSave] firstObject];
            localUser.userinfo = object;
        };
        request;
    });
    
    return [[RCHTTPSessionManager shared] loadRequest:downloadFavoritedProjectsWithNotesRequest].then(^(id mappedObject) {
        return mappedObject;
    }).catch(^(NSError *error) {
        NSLog(@"error %@",error.localizedDescription);
    });
}

+ (EKManagedObjectMapping *)downloadUserInfoMapping {
    return [EKManagedObjectMapping mappingForEntityName:[RCUserInfo rc_className] withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping hasMany:[RCFavoritedProjectInfo class] forKeyPath:@"favorites" forProperty:@"favoritedProjectInfos"];
    }];
}

- (void)addRecentProject:(RCProject *)project completion:(dispatch_block_t)completion {
    @weakify(self);
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        @strongify(self);
        RCUser *localUser = [[RCUser rc_objectsWithValues:@[self.login] ofFieldName:@"login" inContext:localContext] firstObject];
        RCProject *localProject = [[RCProject rc_objectsWithUIDs:@[project.uid] inContext:localContext] firstObject];
        NSMutableOrderedSet *mutableOrderedProjectsSet = [localUser.recentProjects mutableCopy];
        if ([mutableOrderedProjectsSet containsObject:localProject]) {
            [mutableOrderedProjectsSet removeObject:localProject];
        } else if (mutableOrderedProjectsSet.count > 9) {//max 10 items
            [mutableOrderedProjectsSet removeObjectAtIndex:0];
        }
        [mutableOrderedProjectsSet addObject:localProject];
        localUser.recentProjects = mutableOrderedProjectsSet;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        RUN_BLOCK(completion);
    }];
}

- (void)DEBUG_simulateBadTokenCompletion:(dispatch_block_t)completion {
    if (self.authorizationToken.length > 0) {
        NSLog(@"SAVED PASSWORD %@",[[AppState sharedInstance] savedUserPassword]);
        NSLog(@"first user token BEFORE %@",self.authorizationToken);
        
        @weakify(self);
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            @strongify(self);
            NSArray *users = [RCUser rc_objectsWithValues:@[self.login] ofFieldName:@"login" inContext:localContext];
            if (users.count > 0) {
                RCUser *user = [users firstObject];
                user.authorizationToken = [user.authorizationToken stringByReplacingCharactersInRange:NSMakeRange(0, 10) withString:@"1111111111"];//      corrupting token!
            }
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            RUN_BLOCK(completion);
        }];
    }
}

@end
