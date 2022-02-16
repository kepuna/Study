//
//  QuestionBuilder.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZQuestion;

extern NSString *QuestionBuilderErrorDomain;

// 错误JSON的提示枚举
enum {
    QuestionBuilderInvalidJSONError,
    QuestionBuilderMissingDataError,
};

/**
* Construct Question objects from an external representation.
* @note The format of the JSON is driven by the Stack Exchange 1.1 API.
* @see Question
*/

@interface QuestionBuilder : NSObject

/** 提问列表数组
 * Given a string containing a JSON dictionary, return a list of Question objects.
 * @param objectNotation The JSON string
 * @param error By-ref error signalling
 * @return An array of Question objects, or nil (with error set) if objectNotation cannot be parsed.
 * @see Question
 */
- (NSArray *)questionsFromJSON: (NSString *)objectNotation error: (NSError **)error;

/** 为question对象添加详情
 * Add information to a Question object based on a JSON dictionary.
 * @param objectNotation The JSON string
 * @param question The question to fill in
 * @note Due to the design of the Stack Exchange API, it's possible for
 *       this method not to change the content of the Question object.
 *       This is not considered an error.
 * @see Question
 */
- (void)fillInDetailsForQuestion: (ZZQuestion *)question fromJSON: (NSString *)objectNotation;

@end

