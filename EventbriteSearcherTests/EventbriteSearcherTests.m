//
//  EventbriteSearcherTests.m
//  EventbriteSearcherTests
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EVSApiHelper.h"
#import "EVSLocationManager.h"

@interface EventbriteSearcherTests : XCTestCase

@end

@implementation EventbriteSearcherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testAsyncApiSearch {
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"Search Results"];
    
    [[EVSApiHelper sharedInstance] searchEventsForQuery:@"" sinceDate:[NSDate date] nearToLatitude:nil nearToLongitude:nil pageNumber:0 completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
        
        XCTAssertNil(error, @"Error should be nil");
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testSingletonInit {
    EVSLocationManager *manager = [EVSLocationManager sharedInstance];
    XCTAssertNotNil(manager, @"Manager should not be nil");
}

@end
