//
//  StackOverflowCommunicatorDelegate.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  处理json数据的 通信器

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StackOverflowCommunicatorDelegate <NSObject>

/**
 * Signal from the communicator that fetching questions has failed.
 * @param error The error received from the network or server.
 */
- (void)searchingForQuestionsFailedWithError: (NSError *)error;

/**
 * Signal from the communicator that it couldn't retrieve a question body.
 */
- (void)fetchingQuestionBodyFailedWithError: (NSError *)error;

/**
 * Trying to retrieve answers failed.
 * @param error The error that caused the failure.
 */
- (void)fetchingAnswersFailedWithError: (NSError *)error;


/**
 * The communicator received a response from the Stack Overflow search.
 */
- (void)receivedQuestionsJSON: (NSString *)objectNotation;

/**
 * Data corresponding to answers was received by the communicator.
 * @param objectNotation The content returned by the server.
 */
- (void)receivedAnswerListJSON: (NSString *)objectNotation;

/**
 * Data corresponding to question details was received by the communicator.
 * @param objectNotation The content returned by the server.
 */
- (void)receivedQuestionBodyJSON: (NSString *)objectNotation;

@end

NS_ASSUME_NONNULL_END
