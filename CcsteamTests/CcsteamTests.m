//
//  CcsteamTests.m
//  CcsteamTests
//
//  Created by Artem Kulagin on 23.12.16.
//  Copyright © 2016 Recity. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RCGetWeater.h"

@interface CcsteamTests : XCTestCase

@end

@implementation CcsteamTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [RCGetWeater withObject:@{@"q":@"Berlin"} completion:^(id reply, NSError *error, BOOL *handleError) {
        NSLog(@"RCGetWeater %@",reply);
    }];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
