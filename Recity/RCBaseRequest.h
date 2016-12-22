//
//  RCBaseRequest.h
//  Recity
//
//  Created by Dmitriy Doroschuk on 08.04.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EKObjectMapping;

typedef NS_ENUM(NSUInteger, RCHTTPMethod) {
    RCHTTPMethodPost,
    RCHTTPMethodPut,
    RCHTTPMethodGet,
    RCHTTPMethodDelete
};

typedef id (^ObjectBlock)(id object, NSManagedObjectContext *backgroundContextWheretoSave);
typedef void (^EmptyReturnObjectBlock)(id object, NSManagedObjectContext *backgroundContextWheretoSave);

@interface RCBaseRequest : NSObject

/**
 *  if failed and should be resend.
 */
@property (assign, nonatomic) BOOL dateToResend;
@property (assign, nonatomic) RCHTTPMethod method;
/**
 *  RCHTTPMethod to String
 */

@property (copy, nonatomic) NSString *methodString;

@property (copy, nonatomic) NSString *methodName;
@property (copy, nonatomic) NSDictionary *parameters;

@property (strong, nonatomic) EKObjectMapping *objectMapping;

// logic of repeating requests

@property (copy, nonatomic) PMKResolver resolver;
/**
 *  if unique new requests will replace all requests for the same methodname
 */
@property (assign, nonatomic) BOOL unique;
@property (strong, nonatomic) NSURLSessionTask *urlSessionTask;

@property (copy, nonatomic) ObjectBlock mappedObjectForNonparceableObjectBlock;
@property (copy, nonatomic) EmptyReturnObjectBlock actionsBeforeMappingBlock;
@property (copy, nonatomic) EmptyReturnObjectBlock actionsAfterMappingBlock;

@property (copy, nonatomic) ObjectBlock customEntireMappingOfSuccessfullResponceBlock;

@end
