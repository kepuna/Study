//
//  MockStackOverflowManager.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MockStackOverflowManager.h"
#import "ZZTopick.h"

@implementation MockStackOverflowManager
//@synthesize

- (NSInteger)topicFailureErrorCode {
    return topicFailureErrorCode;
}

- (NSInteger)bodyFailureErrorCode {
    return bodyFailureErrorCode;
}

- (NSInteger)answerFailureErrorCode {
    return answerFailureErrorCode;
}

- (void)searchingForQuestionsFailedWithError: (NSError *)error {
    topicFailureErrorCode = [error code];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    bodyFailureErrorCode = [error code];
}

- (void)fetchingAnswersFailedWithError:(NSError *)error {
    answerFailureErrorCode = [error code];
}

- (void)receivedQuestionsJSON:(NSString *)objectNotation {
    topicSearchString = objectNotation;
}

- (void)receivedQuestionBodyJSON:(NSString *)objectNotation {
    questionBodyString = objectNotation;
}

- (void)receivedAnswerListJSON:(NSString *)objectNotation {
    answerListString = objectNotation;
}

- (NSString *)topicSearchString {
    return topicSearchString;
}

- (NSString *)questionBodyString {
    return questionBodyString;
}

- (NSString *)answerListString {
    return answerListString;
}

- (BOOL)didFetchQuestions {
    return wasAskedToFetchQuestions;
}

- (void)fetchQuestionsOnTopic:(ZZTopick *)topic {
    wasAskedToFetchQuestions = YES;
}

- (BOOL)didFetchAnswers {
    return wasAskedToFetchAnswers;
}

- (void)fetchAnswersForQuestion: (ZZQuestion *)question {
    wasAskedToFetchAnswers = YES;
}

- (BOOL)didFetchQuestionBody {
    return wasAskedToFetchBody;
}

- (void)fetchBodyForQuestion:(ZZQuestion *)question {
    wasAskedToFetchBody = YES;
}

@end
