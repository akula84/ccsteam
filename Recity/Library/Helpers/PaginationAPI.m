//
//  PaginationAPI.m
//  
//
//  Created by Alexander Kozin on 12.07.15.
//
//

#import "PaginationAPI.h"
#import "API_Protected.h"

NSUInteger const kAPIFirstPageNumber = 1;

@interface PaginationAPI () {
    NSUInteger _currentPage;
}

@end

@implementation PaginationAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setObjectsPerPage:20/*kAPIDefaultObjectsPerPage*/];
        [self resetToFirstPage];
    }
    return self;
}

- (void)sendRequestWithCompletion:(void (^)(id, NSError *, BOOL *))completion
{
    if ([self isLastPage] && ![self isFirstPage]) {
        // Create custom error for out of bounds request
        NSError *e = [NSError errorWithDomain:@""
                                         code:NSIntegerMax
                                     userInfo:nil];

        [self apiDidFailWithError:e];
        [self apiDidEnd];
    } else {
        [super sendRequestWithCompletion:completion];
    }
}

- (NSMutableDictionary *)parameters
{
    NSMutableDictionary *parameters = [super parameters];

    return parameters;
}

- (void)setObjectsPerPage:(NSUInteger)objectsPerPage
{
    NSParameterAssert(objectsPerPage);

    _objectsPerPage = objectsPerPage;
}

- (BOOL)isFirstPage
{
    return _currentPage == kAPIFirstPageNumber;
}

- (void)requestFromFirstPage
{
    [self resetToFirstPage];
    [self requestNextPage];
}

- (void)requestNextPageFromDate:(NSTimeInterval)date
{
    if (!self.isLastPage && ![self apiRequestInProgress]) {
        [self requestNextPage];
    }
}

- (void)requestNextPage
{
    if (![self apiRequestInProgress]) {
        [self sendRequestWithCompletion:self.completion];
    }
}

- (void)resetToFirstPage
{
    _currentPage = kAPIFirstPageNumber;
    [self setIsLastPage:NO];
    [self setUserInfo:nil];
    [self setNextPageUrl:nil];
}

- (void)apiDidReturnReply:(NSArray *)reply source:(id)source
{
    [self setIsLastPage:YES];
    
    [super apiDidReturnReply:reply source:source];
}

- (NSUInteger)pageNumber
{
    NSUInteger page = _currentPage;
    
    if (self.nextPageUrl.length > 0) {
        NSArray *parameters = [self.nextPageUrl componentsSeparatedByString:@"&"];
        for (NSString *parameter in parameters) {
            NSArray *nameAndValue = [parameter componentsSeparatedByString:@"="];
            if ([[nameAndValue firstObject] isEqualToString:@"page"]) {
                page = (NSUInteger)[[nameAndValue lastObject] intValue];
                break;
            }
        }
    }
    
    return page;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, count:%lu", [super description], (unsigned long)self.objectsPerPage];
}

@end
