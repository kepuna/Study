//
//  MockStackOverflowManagerDelegate.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"
#import "ZZTopick.h"
#import "ZZQuestion.h"
#import "StackOverManager.h"

@implementation MockStackOverflowManagerDelegate

- (void)fetchingQuestionFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)didReceiveQuestions:(NSArray *)questions {
    self.fetchedQuestions = questions;
}

- (void)retrievingAnswersFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)answersReceivedForQuestion:(ZZQuestion *)question {
    self.successQuestion = question;
}

- (void)bodyReceivedForQuestion:(ZZQuestion *)question {
    self.bodyQuestion = question;
}

@end
