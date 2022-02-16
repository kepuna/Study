//
//  MockStackOverflowCommunicator.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackOverCommunicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface MockStackOverflowCommunicator : StackOverCommunicator

- (BOOL)wasAskedToFetchQuestions;
- (BOOL)wasAskedToFetchBody;
- (NSInteger)askedForAnswersToQuestionID;

@end

NS_ASSUME_NONNULL_END
