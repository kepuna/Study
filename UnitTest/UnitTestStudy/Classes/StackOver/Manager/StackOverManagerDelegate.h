//
//  StackOverManagerDelegate.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/8/13.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZQuestion;

@protocol StackOverManagerDelegate <NSObject>


/// 获取提问列表失败了
- (void)fetchingQuestionsFailedWithError:(NSError *)error;

/**
 * The manager retrieved a list of questions from Stack Overflow.
 *
 * 接收提问列表的数据
 */
- (void)didReceiveQuestions: (NSArray *)questions;

/**
 * The manager couldn't fetch a question body.
 * 获取提问的详情失败
 */
- (void)fetchingQuestionBodyFailedWithError: (NSError *)error;


/**
 * The manager couldn't get answers to a question.
 * 获取Answers失败
 */
- (void)retrievingAnswersFailedWithError: (NSError *)error;

/**
 * The manager got a list of answers to a question.
 *
 * 根据question获取Answers
 */
- (void)answersReceivedForQuestion: (ZZQuestion *)question;

/**
 * The manager got the body of a question.
 *
 * 根据question获取提问详情
 */
- (void)bodyReceivedForQuestion: (ZZQuestion *)question;

@end

