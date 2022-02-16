//
//  QuestionCreatiionTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StackOverManager.h"
#import "Mock/MockStackOverflowManagerDelegate.h"
#import "ZZQuestion.h"
#import "ZZTopick.h"
#import "Mock/MockStackOverflowCommunicator.h"

@interface QuestionCreatiionTests : XCTestCase
@end

@implementation QuestionCreatiionTests {
    StackOverManager *mgr;
    MockStackOverflowManagerDelegate *delegate;
    // 通信器（可以获取网络数据）
    MockStackOverflowCommunicator *communicator;
    MockStackOverflowCommunicator *bodyCommunicator;
    
    ZZQuestion *questionToFetch;
    NSError *underlyingError;
    NSArray *questionArray;
}

- (void)setUp {
  
    mgr = [[StackOverManager alloc] init];
    delegate = [MockStackOverflowManagerDelegate new];
    mgr.delegate = delegate;
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    
    communicator = [MockStackOverflowCommunicator new];
    mgr.communicator = communicator;
    bodyCommunicator = [MockStackOverflowCommunicator new];
    mgr.bodyCommunicator = bodyCommunicator;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    mgr = nil;
    delegate = nil;
    communicator = nil;
    bodyCommunicator = nil;
    underlyingError = nil;
}

- (void)testNonCoformingObjectCannotBeDelegate {
    // XCTAssertThrows
    // This function generates a failure if expression doesn’t throw an exception.
    // 异常测试，当expression发生异常时通过；反之不通过；
   
    XCTAssertThrows(mgr.delegate = (id <StackOverManagerDelegate>)[NSNull null], @"Null should not be used as the delegate as does not conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate {
    
    // XCTAssertNoThrow
    // This function generates a failure if expression throws an exception.
    XCTAssertNoThrow(mgr.delegate = delegate, @"Object conforming to the delegate protocol can be delegate");
    
}

// 当使用nil作为delegate时会发生什么 ？
- (void)testManagerAcceptsNilAsADelegate {
    XCTAssertNoThrow(mgr.delegate = nil, @"It should be acceptable to use nil as an object's delegate");
}


// Manager在被问及某个话题的提问列表时，应该向通信器索要数据信息

- (void)testAskingForQuestionsMeansRequestingData {
    ZZTopick *topic = [[ZZTopick alloc] initWithName: @"iPhone" tag: @"iphone"];
    // Manager根据某个话题获取提问列表数组
    [mgr fetchQuestionsOnTopic: topic];
    XCTAssertTrue([communicator wasAskedToFetchQuestions], @"The communicator should need to fetch data.");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator {
    [mgr searchingForQuestionsFailedWithError: underlyingError];
    XCTAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError {
    [mgr searchingForQuestionsFailedWithError: underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError] userInfo] objectForKey: NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
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

@end
