//
//  AnswerBuilder.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZQuestion;

NS_ASSUME_NONNULL_BEGIN


extern NSString *AnswerBuilderErrorDomain;

enum {
    AnswerBuilderErrorInvalidJSONError,
    AnswerBuilderErrorMissingDataError,
};

/**
* Constructing Answer objects from data sent by the Stack Overflow site.
* @see Answer
*/

@interface AnswerBuilder : NSObject


/** 添加回答列表数据到 question对象
 * Populate a question object with the answers
 * supplied by the Stack Overflow web service.
 * @param question The question to which answers are required.
 * @param objectNotation The data containing the answer content.
 * @param error A by-reference error return.
 * @return YES if answers are successfully parsed, otherwise NO and error is filled to describe the problem.
 * @note If the data is valid but there are no answers to add, this is not an error.
 */
- (BOOL)addAnswersToQuestion: (ZZQuestion *)question fromJSON: (NSString *)objectNotation error: (NSError **)error;

@end

NS_ASSUME_NONNULL_END
