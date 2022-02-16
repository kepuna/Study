//
//  QuestionBuilderTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/11.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

/*
 QuestionBuilder类的API已经定义好了，因为在早前设计StackOverflowManager类的过程中需要用到它，我们也可以指明传递给QuestionBuilder对象为nil， 因为如果在先前的处理流程中发生错误，那么StackOverflowManager对象早就会将那个错误处理掉了。 同时，如果传入的字符串不能作为JSON格式被解析，那么QuestionBuilder就会返回nil，
 此时，如果用于接受错误信息的那个参数NULL， 那么就会将错误信息设置到参数所指的对象之中。
 
 */

#import <XCTest/XCTest.h>
#import "QuestionBuilder.h"
#import "ZZQuestion.h"
#import "ZZPerson.h"


static NSString *questionJSON = @"{"
@"\"total\": 1,"
@"\"page\": 1,"
@"\"pagesize\": 30,"
@"\"questions\": ["
@"{"
@"\"tags\": ["
@"\"iphone\","
@"\"security\","
@"\"keychain\""
@"],"
@"\"answer_count\": 1,"
@"\"accepted_answer_id\": 3231900,"
@"\"favorite_count\": 1,"
@"\"question_timeline_url\": \"/questions/2817980/timeline\","
@"\"question_comments_url\": \"/questions/2817980/comments\","
@"\"question_answers_url\": \"/questions/2817980/answers\","
@"\"question_id\": 2817980,"
@"\"owner\": {"
@"\"user_id\": 23743,"
@"\"user_type\": \"registered\","
@"\"display_name\": \"Graham Lee\","
@"\"reputation\": 13459,"
@"\"email_hash\": \"563290c0c1b776a315b36e863b388a0c\""
@"},"
@"\"creation_date\": 1273660706,"
@"\"last_activity_date\": 1278965736,"
@"\"up_vote_count\": 2,"
@"\"down_vote_count\": 0,"
@"\"view_count\": 465,"
@"\"score\": 2,"
@"\"community_owned\": false,"
@"\"title\": \"Why does Keychain Services return the wrong keychain content?\","
@"\"body\": \"<p>I've been trying to use persistent keychain references.</p>\""
@"}"
@"]"
@"}";


static NSString *stringIsNotJSON = @"Not JSON";
static NSString *noQuestionsJSONString = @"{ \"noquestions\": true }";
static NSString *emptyQuestionsArray = @"{ \"questions\": [] }";


@interface QuestionBuilderTests : XCTestCase
@property (nonatomic, strong) QuestionBuilder *questionBuilder;
@property (nonatomic, strong) ZZQuestion *question;
@end

@implementation QuestionBuilderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.questionBuilder = [[QuestionBuilder alloc] init];
    self.question = [[self.questionBuilder questionsFromJSON:questionJSON error:NULL] objectAtIndex:0];
}

- (void)tearDown {
    self.questionBuilder = nil;
    self.question = nil;
}

// 测试 questionsFromJSON 是否传入的一个不支持的nil参数
- (void)testThatNilIsNotAnAcceptableParameter {
    XCTAssertThrows([self.questionBuilder questionsFromJSON: nil error: NULL], @"Lack of data should have been handled elsewhere");
}

// 测试当questionsFromJSON 传入的字符串不是一个JSON格式时是否返回nil
- (void)testNilReturnedWhenStringIsNotJSON {
    XCTAssertNil([self.questionBuilder questionsFromJSON: stringIsNotJSON error: NULL], @"This parameter should not be parsable");
}

// 测试当questionsFromJSON 传入的字符串不是一个JSON格式时，是否有Error信息
- (void)testErrorSetWhenStringIsNotJSON {
    NSError *error = nil;
    [self.questionBuilder questionsFromJSON: stringIsNotJSON error: &error];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash {
    XCTAssertNoThrow([self.questionBuilder questionsFromJSON: stringIsNotJSON error: NULL], @"Using a NULL error parameter should not be a problem");
}

/*
 假设QuestionBuilder所接收的数据是JSON格式的，那么接下来我们首先要确认的就是，在待解析的数据中包含名为questions的数组。
 */
- (void)testRealJSONWithoutQuestionsArrayIsError {
    XCTAssertNil([self.questionBuilder questionsFromJSON: noQuestionsJSONString error: NULL], @"No questions to parse in this JSON");
}

// 现有的QuestionBuilder类仅包含名为QuestionBuilderInvalidJSONError 的错误信息代码，这不够准确。因为测试所用的是符合JSON格式的合法数据，但是QuestionBuilder却没有给出包含必要信息的错误提示来，我们来修改返回的错误信息代码，使之更加准确。
- (void)testRealJSONWithoutQuestionsReturnsMissingDataError {
    NSError *error = nil;
    [self.questionBuilder questionsFromJSON: noQuestionsJSONString error: &error];
    XCTAssertEqual([error code], QuestionBuilderMissingDataError, @"This case should not be an invalid JSON error");
}


/// 创建一条question
- (void)testJSONWithOneQuestionReturnsOneQuestionObject {
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON: questionJSON error: &error];
    XCTAssertEqual([questions count], (NSUInteger)1, @"The builder should have created a question");
}

//- (void)testQuestionCreatedFromJSONHasPropertiesPresentedInJSON {
//    XCTAssertEqual(self.question.questionID, 2817980, @"The question ID should match the data we sent");
//    XCTAssertEqual([self.question.date timeIntervalSince1970], (NSTimeInterval)1273660706, @"The date of the question should match the data");
//    XCTAssertEqualObjects(self.question.title, @"Why does Keychain Services return the wrong keychain content?", @"Title should match the provided data");
//    XCTAssertEqual(self.question.score, 2, @"Score should match the data");
////    ZZPerson *asker = self.question.asker;
////    XCTAssertEqualObjects(asker.name, @"Graham Lee", @"Looks like I should have asked this question");
////    XCTAssertEqualObjects([asker.avatarURL absoluteString], @"http://www.gravatar.com/avatar/563290c0c1b776a315b36e863b388a0c", @"The avatar URL should be based on the supplied email hash");
//}


- (void)testQuestionCreatedFromEmptyObjectIsStillValidObject {
    NSString *emptyQuestion = @"{ \"questions\": [ {} ] }";
    NSArray *questions = [self.questionBuilder questionsFromJSON: emptyQuestion error: NULL];
    XCTAssertEqual([questions count], (NSUInteger)1, @"QuestionBuilder must handle partial input");
}

/// 提问详情 No Data的情况
- (void)testBuildingQuestionBodyWithNoDataCannotBeTried {
    XCTAssertThrows([self.questionBuilder fillInDetailsForQuestion: self.question fromJSON: nil], @"Not receiving data should have been handled earlier");
}

- (void)testBuildingQuestionBodyWithNoQuestionCannotBeTried {
    XCTAssertThrows([self.questionBuilder fillInDetailsForQuestion: nil fromJSON: questionJSON], @"No reason to expect that a nil question is passed");
}


- (void)testNonJSONDataDoesNotCauseABodyToBeAddedToAQuestion {
    [self.questionBuilder fillInDetailsForQuestion: self.question fromJSON: stringIsNotJSON];
    XCTAssertNil(self.question.body, @"Body should not have been added");
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded {
    [self.questionBuilder fillInDetailsForQuestion: self.question fromJSON: noQuestionsJSONString];
    XCTAssertNil(self.question.body, @"There was no body to add");
}

//- (void)testBodyContainedInJSONIsAddedToQuestion {
//    [self.questionBuilder fillInDetailsForQuestion:self.question fromJSON:questionJSON];
//    XCTAssertEqualObjects(self.question.body, @"<p>I've been trying to use persistent keychain references.</p>", @"The correct question body is added");
//}

- (void)testEmptyQuestionsArrayDoesNotCrash {
    XCTAssertNoThrow([self.questionBuilder fillInDetailsForQuestion: self.question fromJSON: emptyQuestionsArray], @"Don't throw if no questions are found");
}

/*
 AnswerBuilder 类的代码和QuestionBuilder也非常相似。 这两个类都需要包含Person类型的实例， 该类用来指代提出问题 或者回答问题的用户。
 
 为此，笔者对QuestionBuilder类中用于构建Person实力的代码进行了重构，将其提取到单独的UserBuilder类中以便复用。
 
 至此，应用程序已经可以将StackOverflow API返回的JSON数据构建成可以展示给用户的Question对象了。
 在编写用于显示的代码之前，只剩下一件事情没有做了。 就是通过网络下载相关数据， 这将是下一章的主题。
 
 */


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
