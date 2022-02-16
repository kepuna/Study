//
//  TopicTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/30.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZZTopick.h"
#import "ZZQuestion.h"

@interface TopicTests : XCTestCase

@property (nonatomic, strong) ZZTopick *topick;

@end

@implementation TopicTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.topick = [[ZZTopick alloc] initWithName:@"Java" tag:@"IT"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.topick = nil;
}

- (void)testThatTopickExits {
    XCTAssertNotNil(self.topick, @"should be able to create a Topic instance");
}

- (void)testThatTopickCanBeNamed {
    
    XCTAssertEqualObjects(self.topick.name, @"Java", @"the Topic should have the name I gave it");
}

- (void)testThatTopickHasTag {
    XCTAssertEqualObjects(self.topick.tag, @"IT", @"the Topic should have the tag I gave it");
    
}

// Test Question
- (void)testForInitiallyEmptyQuestionList {
    XCTAssertEqual(self.topick.recentQuestions.count, (NSInteger)0, @"No Questions added yet, count should be zero");
}

- (void)testAddingAQuestionToTheList {
    ZZQuestion *question = [[ZZQuestion alloc] init];
    [self.topick addQuestion:question];
    XCTAssertEqual(self.topick.recentQuestions.count, (NSInteger)1, @"Add a question, and the count of questions should go up");
}

- (void)testForAListOfQuestions {
    XCTAssertTrue([self.topick.recentQuestions isKindOfClass:[NSArray class]], @"Topick should provide a list of rencent question");
}


// 任何0个或1个的对象的列表总可以保证是按照时间顺序排列的，那么含有两个对象的列表又如何那 ？

- (void)testQuestionsAreListedChronologically {
    ZZQuestion *question1 = [[ZZQuestion alloc] init];
    question1.date = [NSDate distantPast]; // 时间下限
    
    ZZQuestion *question2 = [[ZZQuestion alloc] init];
    question2.date = [NSDate distantFuture]; // 时间上限
    
    [self.topick addQuestion:question1];
    [self.topick addQuestion:question2];
    
    NSArray *questions = [self.topick recentQuestions];
    ZZQuestion *listedFirst = [questions objectAtIndex:0];
    ZZQuestion *listedSecond = [questions objectAtIndex:1];
    
    XCTAssertEqualObjects([listedFirst.date laterDate:listedSecond.date].description, listedFirst.date.description, @"The later question should appear first in the list");
}

// 确保只有最近20个提问会被现实出来
- (void)testLimitOfTwentyQuestions {
    ZZQuestion *q1 = [ZZQuestion new];
    for (NSInteger i=0; i<25; i++) {
        [self.topick addQuestion:q1];
    }
    XCTAssertTrue(self.topick.recentQuestions.count < 21, @"There should never be more than twenty questions");
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
