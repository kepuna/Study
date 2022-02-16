//
//  StackOverManager.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "StackOverManager.h"
#import "StackOverflowCommunicatorDelegate.h"
#import "StackOverCommunicator.h"
#import "ZZTopick.h"
#import "ZZQuestion.h"
#import "QuestionBuilder.h"
#import "AnswerBuilder.h"
#import "StackOverManagerDelegate.h"

NSString *StackOverflowManagerError = @"StackOverflowManagerError";

@implementation StackOverManager

- (void)setDelegate:(id<StackOverManagerDelegate>)newDelegate {
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(StackOverManagerDelegate)]) {
         [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol" userInfo: nil] raise];
    }
    _delegate = newDelegate;
}

#pragma mark - Questions
- (void)fetchQuestionsOnTopic:(ZZTopick *)topic {
    [self.communicator searchForQuestionsWithTag:topic.tag];
}

- (void)fetchBodyForQuestion:(ZZQuestion *)question {
    NSLog(@"999999=++++ %@----%@",question,self.bodyCommunicator);
    self.questionNeedingBody = question;
    [self.bodyCommunicator downloadInformationForQuestionWithID:question.questionID];
}

/// 接收到提问列表的json数据
/// 然后通过Builder类(QuestionBuilder)来构建数据
- (void)receivedQuestionsJSON:(NSString *)objectNotation {
    
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    if (questions == nil) {
        [self _tellDelegateAboutQuestionSearchError:error];
    } else {
        [self.delegate didReceiveQuestions:questions];
    }
}

// 接收到提问详情的json数据
- (void)receivedQuestionBodyJSON:(NSString *)objectNotation {
   
    // 处理好的数据放在 questionNeedingBody里
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJSON:objectNotation];
    
    // 通过代理回调出去
    if (self.delegate && [self.delegate respondsToSelector:@selector(bodyReceivedForQuestion:)]) {
        [self.delegate bodyReceivedForQuestion:self.questionNeedingBody];
        self.questionNeedingBody = nil;
    }
}

#pragma mark - StackOverflowCommunicatorDelegate

// 搜索提问列表出错
- (void)searchingForQuestionsFailedWithError:(NSError *)error {
    [self _tellDelegateAboutQuestionSearchError:error];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    NSDictionary *errorInfo = nil;
    if (error) {
        errorInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: StackOverflowManagerError code: StackOverflowManagerErrorQuestionBodyFetchCode userInfo:errorInfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fetchingQuestionBodyFailedWithError:)]) {
        [self.delegate fetchingQuestionBodyFailedWithError:reportableError];
    }
    self.questionNeedingBody = nil;
}


#pragma mark Answers - 处理Answers的数据
/// 请求answers数据
- (void)fetchAnswersForQuestion:(ZZQuestion *)question {
    self.questionToFill = question;
    
    [self.communicator downloadAnswersToQuestionWithID:question.questionID];
}

/// 请求answers数据失败了
- (void)fetchingAnswersFailedWithError:(NSError *)error {
    self.questionToFill = nil;
    NSDictionary *userInfo = nil;
    if (error) {
        userInfo = [NSDictionary dictionaryWithObject: error forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: StackOverflowManagerError code:StackOverflowManagerErrorAnswerFetchCode userInfo: userInfo];
    [self.delegate retrievingAnswersFailedWithError: reportableError];
}

/// 接受AnswerList 的json数据
- (void)receivedAnswerListJSON:(NSString *)objectNotation {
    NSError *error = nil;
    // 处理json数据
    if ([self.answerBuilder addAnswersToQuestion:self.questionToFill fromJSON:objectNotation error:&error]) {
        // 将处理好的数据通过 questionToFill 回调出去
        [self.delegate answersReceivedForQuestion: self.questionToFill];
        self.questionToFill = nil;
    } else {
        [self fetchingAnswersFailedWithError:error];
    }
}

#pragma mark Class Continuation
- (void)_tellDelegateAboutQuestionSearchError:(NSError *)underlyingError {
    
    NSDictionary *errorInfo = nil;
    if (underlyingError) {
        errorInfo = [NSDictionary dictionaryWithObject: underlyingError forKey: NSUnderlyingErrorKey];
    }
    NSError *reportableError = [NSError errorWithDomain: StackOverflowManagerError code: StackOverflowManagerErrorQuestionSearchCode userInfo: errorInfo];
    
    // 通知代理 - StackOverManagerDelegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(fetchingQuestionsFailedWithError:)]) {
        [self.delegate fetchingQuestionsFailedWithError:reportableError];
    }
    
}

@end
