//
//  AnswerTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZZAnswer.h"
#import "ZZPerson.h"

@interface AnswerTests : XCTestCase
@property (nonatomic, strong) ZZAnswer *answer;
@end

@implementation AnswerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.answer = [ZZAnswer new];
    self.answer.text = @"The answer is 42";
    self.answer.person = [[ZZPerson alloc] initWithName:@"JiaJung" avatarLocation:@"https://lh3.googleusercontent.com/proxy/6m8PF-9APstS3YvmAkzlRiIdVFwgXR8WPdOD5QZC3Q2uKOb2AQ8794pwxWoTsDz5EoyaXKDXl8MuynI908rhcXQpyXNc2RdgIn3gJfUiVwI"];
    self.answer.score = 42;
    
    
}

- (void)testAnswerHasText {
    XCTAssertEqualObjects(self.answer.text, @"The answer is 42", @"Answers need to contain some text");
}

- (void)testSomeProvidedTheAnswer {
    XCTAssertTrue([self.answer.person isKindOfClass:[ZZPerson class]], @"A Person gave this Answer");
    
}

- (void)testAnswersNotAcceptedByDefault {
    XCTAssertFalse(self.answer.accepted, @"Answer not accepted by default");
}

- (void)testAnswerCanBeAccepted {
    XCTAssertNoThrow(self.answer.accepted = YES, @"It is possible to accept an answer");
}

- (void)testAnswerHasScore {
    XCTAssertTrue(self.answer.score == 42, @"Answer`s score can be retrieved");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.answer = nil;
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
