//
//  RCHTTPSessionManager.m
//  Recity
//
//  Created by Dmitriy Doroschuk on 08.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import "RCHTTPSessionManager.h"
#import <EasyMapping/EasyMapping.h>
#import "Reachability.h"
#import "RCUser.h"
#import "AppState.h"


@interface AFHTTPSessionManager ()


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@interface RCHTTPSessionManager ()

@property (strong, nonatomic) NSMutableArray *requests;
@property (strong, nonatomic) Reachability *reachability;

@property (strong, nonatomic) RCBaseRequest *refreshingTokenRequest;
@property (assign, nonatomic) BOOL nowRefreshingToken;
@property (strong, nonatomic) NSString *lastUsedUserPassword;

@end

@implementation RCHTTPSessionManager
{
    BOOL _hasInternetConnection;
}

#pragma mark - LifeCycle

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    static RCHTTPSessionManager *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] initWithBaseURL: [NSURL URLWithString:[self baseURLString]]];
        [[NSNotificationCenter defaultCenter] addObserver:shared selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

        shared.reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
        [shared.reachability startNotifier];
    });
    
    return shared;
}

- (void)reachabilityChanged:(id)note {
    switch ([self.reachability currentReachabilityStatus]) {
        case NotReachable: {
            if (self->_hasInternetConnection) {
                [self suspendAllTasks];
            }
            self->_hasInternetConnection = NO;
        }
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            if (!self->_hasInternetConnection) {
                if (_nowRefreshingToken) {
                    [self loadRequest:self.refreshingTokenRequest uploadProgress:nil downloadProgress:nil resolver:self.refreshingTokenRequest.resolver];
                } else {
                    [self restartAllTasks];
                }
            }
            self->_hasInternetConnection = YES;
        }
            break;
    }
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL: url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"application/json"]];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - Utils

+ (NSString *)baseURLString
{
    static NSString * const baseURL = @"http://recity-dev.azurewebsites.net/api/";
    
    return baseURL;
}

- (NSMutableArray *)requests {
    return _requests ?: (_requests = [NSMutableArray array]);
}

#pragma mark - Restarting requests

- (void)suspendAllTasks {
    if (self.dataTasks.count > 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    for (NSURLSessionDataTask *task in self.dataTasks) {
        [task cancel];
    }
}

- (void)restartAllTasks {
    if (self.dataTasks.count > 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } 
    NSArray *requests = [self.requests copy];
    NSLog(@"PENDING REQUESTS %@",[requests valueForKey:@"methodName"]);
    for (RCBaseRequest *request in requests) {
        [self loadRequest:request uploadProgress:nil downloadProgress:nil resolver:request.resolver];
    }
}

#pragma mark - Networking

- (PMKPromise *)loadRequest:(RCBaseRequest *)request {
    
    return [self loadRequest:request uploadProgress:nil downloadProgress:nil];
}

- (PMKPromise *)loadRequest:(RCBaseRequest *)request uploadProgress:(ProgressBlock)uploadProgress downloadProgress:(ProgressBlock)downloadProgress {
    
    NSLog(@"REQUEST: %@", request.parameters);
    return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self loadRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress resolver:resolve];
    }];
}

- (BOOL)repornNetworkProblemIfNeededWithCancelBlock:(EmptyBlock)cancelBlock retryBlock:(EmptyBlock)retryBlock {
    BOOL networkAvailable = [self.reachability currentReachabilityStatus] != NotReachable;
    if (networkAvailable) {
        return NO;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"No internet connection" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:({
        [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            PERFORM_BLOCK_IF_NOT_NIL(cancelBlock);
        }];
    })];
    [alertController addAction:({
        [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PERFORM_BLOCK_IF_NOT_NIL(retryBlock)
        }];
    })];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    return YES;
}

- (void)loadRequest:(RCBaseRequest *)request uploadProgress:(ProgressBlock)uploadProgress downloadProgress:(ProgressBlock)downloadProgress resolver:(PMKResolver)resolve {
    request.resolver = resolve;
    if (request.unique) {
        NSMutableArray *replacedByUniqueRequests = [NSMutableArray array];
        [self.requests enumerateObjectsUsingBlock:^(RCBaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.methodName isEqualToString:request.methodName]) {
                [replacedByUniqueRequests addObject:obj];
                [obj.urlSessionTask suspend];
            }
        }];
        [self.requests removeObjectsInArray:replacedByUniqueRequests];
    }
    [self.requests addObject:request];
    request.resolver = resolve;
    
    @weakify(self)
    BOOL (^noConnectionBlock)() = ^BOOL{
        return [self repornNetworkProblemIfNeededWithCancelBlock:^{
            resolve([[NSError alloc]initWithDomain:@"" code:0 userInfo:nil]);
        } retryBlock:^{
            @strongify(self)
            [self loadRequest:request uploadProgress:nil downloadProgress:nil resolver:resolve];
        }];
    };
    
    if (noConnectionBlock()) {
        
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [self dataTaskWithHTTPMethod:request.methodString URLString:request.methodName parameters:request.parameters uploadProgress:uploadProgress downloadProgress:downloadProgress success:^(NSURLSessionDataTask *task, id object) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self.requests removeObject:request];
        [request.urlSessionTask suspend];
        
//        NSLog(@"RESPONSE %@", object);
        
        BOOL responcedObjectIsDictionary = [object isKindOfClass:[NSDictionary class]];
        BOOL responcedObjectIsArray = [object isKindOfClass:[NSArray class]];
        BOOL responcedObjectIsNumber = [object isKindOfClass:[NSNumber class]];
        
        if (object && !responcedObjectIsDictionary && !responcedObjectIsArray && !responcedObjectIsNumber) {
            NSAssert2(NO, @"responce in method %@ has not dictionary: %@", request.parameters[@"_type"], object);
            return;
        }
        
        __block id mappedObject = object;
        __block NSManagedObjectID *mappedObjectID;
        EKManagedObjectMapping *mapping = (id)request.objectMapping;
        void (^mapObject)(NSManagedObjectContext *contextWheretoSave) = ^(NSManagedObjectContext *backgroundContextWheretoSave){
            RUN_BLOCK(request.actionsBeforeMappingBlock, mappedObject, backgroundContextWheretoSave);
            if (responcedObjectIsDictionary) {
                mappedObject = [EKManagedObjectMapper objectFromExternalRepresentation:mappedObject withMapping:mapping inManagedObjectContext:backgroundContextWheretoSave];
                mappedObjectID = ((NSManagedObject *)mappedObject).objectID;
            } else if (responcedObjectIsArray) {
                mappedObject = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:mappedObject withMapping:mapping inManagedObjectContext:backgroundContextWheretoSave];
            } else {
                if (request.mappedObjectForNonparceableObjectBlock) {
                    mappedObject = request.mappedObjectForNonparceableObjectBlock(mappedObject, backgroundContextWheretoSave);
                }
//                mappedObject = RUN_BLOCK(request.needCreateDBobjectForNonparceableObjectBlock, mappedObject);// [EKManagedObjectMapper objectFromExternalRepresentation:mappedObject withMapping:mapping inManagedObjectContext:backgroundContextWheretoSave];
                mappedObjectID = ((NSManagedObject *)mappedObject).objectID;
            }
            RUN_BLOCK(request.actionsAfterMappingBlock, mappedObject, backgroundContextWheretoSave);
        };
        
        if ([mapping isMemberOfClass:[EKObjectMapping class]]) {
            mappedObject = [EKMapper objectFromExternalRepresentation:mappedObject withMapping:request.objectMapping];
        } else if ([mapping isKindOfClass:[EKManagedObjectMapping class]] || mapping == nil) {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull privateRootContext) {
                @try {
                    if (request.customEntireMappingOfSuccessfullResponceBlock) {
                        mappedObject = request.customEntireMappingOfSuccessfullResponceBlock(mappedObject, privateRootContext);
                    } else {
                        mapObject(privateRootContext);
                    }
                } @catch (NSException *exception) {}
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                BOOL mappedObjectIsDictionary = [mappedObject isKindOfClass:[NSDictionary class]];
                BOOL mappedObjectIsArray = [mappedObject isKindOfClass:[NSArray class]];
                BOOL mappedObjectIsNumber = [mappedObject isKindOfClass:[NSNumber class]];
                
                id restoredMappedObject;
                BOOL willRestoreAsSingleObject = (!request.customEntireMappingOfSuccessfullResponceBlock && (responcedObjectIsDictionary || responcedObjectIsNumber)) || (request.customEntireMappingOfSuccessfullResponceBlock && (mappedObjectIsDictionary || mappedObjectIsNumber));
                BOOL willRestoreAsArray = (!request.customEntireMappingOfSuccessfullResponceBlock && responcedObjectIsArray) || (request.customEntireMappingOfSuccessfullResponceBlock && mappedObjectIsArray);
                if (willRestoreAsSingleObject) {
                    NSManagedObjectID *objectID = ((NSManagedObject *)mappedObject).objectID;//     object might be deleted from DB at this moment
                    if (objectID) {
                        restoredMappedObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectID];
                    } else {
                        NSLog(@"OBJECT HAS DELETED BEFORE RESTORING ! %@",objectID);
                    }
                    NSLog(@"USERS IN ROOT %@ %@",[RCUser MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]],[[RCUser MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]] valueForKey:@"authorizationToken"]);
                    NSLog(@"USERS IN DEFAULT %@ %@",[RCUser MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]],[[RCUser MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]] valueForKey:@"authorizationToken"]);
                    PERFORM_BLOCK_IF_NOT_NIL(resolve, restoredMappedObject);
                } else if (willRestoreAsArray) {
                    NSMutableArray *restoredMappedObjects = [@[] mutableCopy];
                    for (NSManagedObject *object in mappedObject) {
                        NSManagedObject *currentMainContextObject = [[NSManagedObjectContext MR_defaultContext] objectWithID:object.objectID];
                        if (currentMainContextObject) {
                            [restoredMappedObjects addObject:currentMainContextObject];
                        } else {
                            NSParameterAssert(NO);
                        }
                    }
                    PERFORM_BLOCK_IF_NOT_NIL(resolve, restoredMappedObjects);
                } else {
                    PERFORM_BLOCK_IF_NOT_NIL(resolve, restoredMappedObject);
                }
            }];
            return;
        }
        
        PERFORM_BLOCK_IF_NOT_NIL(resolve, mappedObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSLog(@"REQUEST FAILED: %@", error.localizedDescription);
        if (noConnectionBlock()) {
            __unused NSArray *requests = [self.requests copy];
            NSLog(@"PENDING REQUESTS %@",[requests valueForKey:@"methodName"]);
            if (self.nowRefreshingToken) {
                [self removeAllAuthorizationRequestsFromQueue];//       we send refresh token request when internet will appear
            }
            return;
        }
        
        NSUInteger code = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        if (error && code == 401) {//     token has expired. Will refresh it
            if (!self.nowRefreshingToken) {
                self.nowRefreshingToken = YES;
                [self reauthorizeCurrentUser].then(^(RCUser *user) {
                    self.nowRefreshingToken = NO;
                    self.refreshingTokenRequest = nil;
                    if (user.authorizationToken.length == 0) {
                        return;
                    }
                    [AppState sharedInstance].user = user;
                    [[AppState sharedInstance] saveUserPasswordToKeychain:self.lastUsedUserPassword];

                    [self restartAllTasks];
                }).catch(^(NSError *error) {
                    [self removeAllAuthorizationRequestsFromQueue];
                });
            }
        } else {
            //TODO: if request garantee - resume task in n sec or when network available
            
            if (code != 0) {
                error = [NSError errorWithDomain:error.domain code:code userInfo:error.userInfo];
            }
            PERFORM_BLOCK_IF_NOT_NIL(resolve, error);
        }
    }];
    
    request.urlSessionTask = task;
    
    [task resume];
}

- (void)removeAllAuthorizationRequestsFromQueue {
    NSMutableArray *removedAuthorizationRequests = [NSMutableArray array];//    stop and remove all authorization requests (original request and request for refresing of token)
    [self.requests enumerateObjectsUsingBlock:^(RCBaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.methodName isEqualToString:[self authorizationMethodName]]) {
            [removedAuthorizationRequests addObject:obj];
            [obj.urlSessionTask suspend];
        }
    }];
    [self.requests removeObjectsInArray:removedAuthorizationRequests];
    //        here nowRefreshingToken in progress still!
}

#pragma mark - Reauthorization

- (PMKPromise *)reauthorizeCurrentUser {
    PMKPromise *result = [self authWithLogin:[AppState sharedInstance].user.login password:[[AppState sharedInstance] savedUserPassword] saveRefreshingTokenRequest:YES];
    return result;
}

- (PMKPromise *)authWithLogin:(NSString *)login password:(NSString *)password {
    PMKPromise *result = [self authWithLogin:login password:password saveRefreshingTokenRequest:NO];
    return result;
}

- (PMKPromise *)authWithLogin:(NSString *)login password:(NSString *)password saveRefreshingTokenRequest:(BOOL)saveRefreshingTokenRequest {
    NSParameterAssert(login.length > 0);
    NSParameterAssert(password.length > 0);
    
    if (login.length == 0 || password.length == 0) {
        return [PMKPromise promiseWithValue:[NSError new]];
    }
    
    RCBaseRequest *authorization = ({
        RCBaseRequest *request = [RCBaseRequest new];
        request.methodString = @"POST";
        request.methodName = [self authorizationMethodName];
        request.unique = YES;
        request.objectMapping = [self authMapping];
        request.parameters = ({
            @{
              @"login" : login,
              @"password" : password,
              };
        });
        request;
    });
    if (saveRefreshingTokenRequest) {
        self.refreshingTokenRequest = authorization;
    }
    self.lastUsedUserPassword = password;

    return [[RCHTTPSessionManager shared] loadRequest:authorization uploadProgress:^(NSProgress *progress) {
        NSLog(@"uploadProgress %@", progress);
    } downloadProgress:^(NSProgress *progress) {
        NSLog(@"downloadProgress %@", progress);
    }].then(^(RCUser *user) {
        RCUser *mainContextUser = [[RCUser rc_objectsWithValues:@[user.login] ofFieldName:@"login" inContext:[NSManagedObjectContext MR_defaultContext]] firstObject];
        return mainContextUser;
    });
}

- (NSString *)authorizationMethodName {
    NSString *result = @"SignIn";
    return result;
}

- (EKManagedObjectMapping *)authMapping {
    return [EKManagedObjectMapping mappingForEntityName:[RCUser rc_className] withBlock:^(EKManagedObjectMapping *mapping) {
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

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[url absoluteString] parameters:parameters error:&serializationError];
    
    NSString *token = [AppState sharedInstance].user.authorizationToken;
    if (token.length > 0) {
        NSString *cookieValue = [NSString stringWithFormat:@".ASPXAUTH=%@", token];
        [request setValue:cookieValue forHTTPHeaderField:@"Cookie"];
        [request setValue:@"25" forHTTPHeaderField:@"Content-Version"];
    }
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}


- (NSDictionary *)encodingParams:(NSDictionary *)parameters {
    NSMutableDictionary *mParameters = [NSMutableDictionary dictionary];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * stop) {
        if ([parameters[key] isKindOfClass:[NSString class]]) {
            NSString *value = parameters[key];
            value = [value stringByRemovingPercentEncoding];
            mParameters[key] = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
            mParameters[key] = parameters[key];
        }
    }];
    return mParameters;
}

@end
