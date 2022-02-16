//
//  QuestionTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/30.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZZQuestion.h"

@interface QuestionTests : XCTestCase
@property (nonatomic, strong) ZZQuestion *question;
@end

@implementation QuestionTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.question = [ZZQuestion new];
    self.question.title = @"Do iPhones Title";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.question = nil;
}

- (void)testQuestionHasDate {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    NSDate *testDate = [NSDate distantPast];
//    self.question.date = testDate;
//    XCTAssertEqualObjects(self.question.date, testDate,@"Questions need to provide its date");
}

- (void)testQuestionHasTitle {
    XCTAssertEqualObjects(self.question.title , @"Do iPhones Title", @"Question should know its title");
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
