//
//  MockStackOverflowManager.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@class ZZTopick;
@class ZZQuestion;

@interface MockStackOverflowManager : NSObject <StackOverflowCommunicatorDelegate> {
    
    NSInteger topicFailureErrorCode;
    NSInteger bodyFailureErrorCode;
    NSInteger answerFailureErrorCode;
    NSString *topicSearchString;
    NSString *questionBodyString;
    NSString *answerListString;
    BOOL wasAskedToFetchQuestions;
    BOOL wasAskedToFetchAnswers;
    BOOL wasAskedToFetchBody;
}

- (NSInteger)topicFailureErrorCode;
- (NSInteger)bodyFailureErrorCode;
- (NSInteger)answerFailureErrorCode;

- (NSString *)topicSearchString;
- (NSString *)questionBodyString;
- (NSString *)answerListString;

- (BOOL)didFetchQuestions;
- (BOOL)didFetchAnswers;
- (BOOL)didFetchQuestionBody;

- (void)fetchQuestionsOnTopic: (ZZTopick *)topic;
- (void)fetchAnswersForQuestion: (ZZQuestion *)question;
- (void)fetchBodyForQuestion: (ZZQuestion *)question;

@property (strong) id delegate;
@end

NS_ASSUME_NONNULL_END
