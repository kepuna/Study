//
//  StackOverManager.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"
@protocol StackOverManagerDelegate;
//#import "StackOverManagerDelegate.h"

@class ZZTopick;
@class ZZQuestion;
@class StackOverCommunicator;
@class QuestionBuilder;
@class AnswerBuilder;

extern NSString *StackOverflowManagerError;

enum {
    StackOverflowManagerErrorQuestionSearchCode,
    StackOverflowManagerErrorQuestionBodyFetchCode,
    StackOverflowManagerErrorAnswerFetchCode
};


@interface StackOverManager : NSObject <StackOverflowCommunicatorDelegate>

@property (nonatomic, weak) id<StackOverManagerDelegate> delegate;

// 数据请求获取
// Manager在被问及某个话题的提问列表时，应该向通信器索要数据信息，这个互动关系可以通过测试方法在 QuestionCreatiionTests 的 testAskingForQuestionsMeansRequestingData
@property (nonatomic, strong) StackOverCommunicator *communicator;

@property (nonatomic, strong) StackOverCommunicator *bodyCommunicator;

@property (nonatomic, strong) QuestionBuilder *questionBuilder;

@property (nonatomic, strong) AnswerBuilder *answerBuilder;

// Question
@property (strong) ZZQuestion *questionToFill; // 待填充数据的question对象
@property (strong) ZZQuestion *questionNeedingBody;

/// 获取某个话题上的提问列表
- (void)fetchQuestionsOnTopic: (ZZTopick *)topic;

/// 获取某个问题的详情
- (void)fetchBodyForQuestion: (ZZQuestion *)question;

/// 获取某个问题的回答列表
- (void)fetchAnswersForQuestion: (ZZQuestion *)question;

@end


