//
//  MockStackOverflowCommunicator.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MockStackOverflowCommunicator.h"

@implementation MockStackOverflowCommunicator {
    
    BOOL wasAskedToFetchQuestions;
    BOOL wasAskedToFetchBody;
    NSInteger questionID;
}

- (id)init {
    if ((self = [super init])) {
        questionID = NSNotFound;
    }
    return self;
}
// 以下代码所做的工作就是在API方法被调用时将标志位设定为YES
- (void)searchForQuestionsWithTag:(NSString *)tag {
    wasAskedToFetchQuestions = YES;
}

- (void)downloadInformationForQuestionWithID:(NSInteger)identifier {
    wasAskedToFetchBody = YES;
}

- (void)downloadAnswersToQuestionWithID:(NSInteger)identifier {
    questionID = identifier;
}


- (BOOL)wasAskedToFetchQuestions {
    return wasAskedToFetchQuestions;
}

- (BOOL)wasAskedToFetchBody {
    return wasAskedToFetchBody;
}

- (NSInteger)askedForAnswersToQuestionID {
    return questionID;
}

@end
