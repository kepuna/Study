//
//  AnswerBuilder.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "AnswerBuilder.h"
#import "ZZAnswer.h"
#import "ZZQuestion.h"
#import "UserBuilder.h"

NSString *AnswerBuilderErrorDomain = @"AnswerBuilderErrorDomain";

@implementation AnswerBuilder

- (BOOL)addAnswersToQuestion:(ZZQuestion *)question fromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing  _Nullable *)error {
    
    NSParameterAssert(objectNotation != nil);
    NSParameterAssert(question != nil);
    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
    NSDictionary *answerData = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0  error: &localError];
    
    // no data
    if (answerData == nil) {
        if (error) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain: AnswerBuilderErrorDomain code: AnswerBuilderErrorInvalidJSONError userInfo: userInfo];
        }
        return NO;
    }
    
//    NSArray *answers = [answerData objectForKey: @"answers"];
    NSDictionary *dataDict = [answerData objectForKey: @"data"];
    NSArray *answers = [dataDict objectForKey: @"list"];
    if (answers == nil) {
        if (error) {
            *error = [NSError errorWithDomain: AnswerBuilderErrorDomain code:AnswerBuilderErrorMissingDataError userInfo: nil];
        }
        return NO;
    }
    
    for (NSDictionary *answerData in answers) {
//        ZZAnswer *thisAnswer = [[ZZAnswer alloc] init];
//        thisAnswer.text = [answerData objectForKey: @"body"];
//        thisAnswer.accepted = [[answerData objectForKey: @"accepted"] boolValue];
//        thisAnswer.score = [[answerData objectForKey: @"score"] integerValue];
//        NSDictionary *ownerData = [answerData objectForKey: @"owner"];
//        thisAnswer.person = [UserBuilder personFromDictionary: ownerData];
//        [question addAnswer: thisAnswer];
        
        ZZAnswer *thisAnswer = [[ZZAnswer alloc] init];
        thisAnswer.text = [answerData objectForKey: @"info"];
        thisAnswer.accepted = [[answerData objectForKey: @"serialState"] boolValue];
        thisAnswer.score = [[answerData objectForKey: @"playsCounts"] integerValue];
        
        NSDictionary *ownerValues = @{
            @"nickname":[answerData objectForKey: @"nickname"]?:@"",
            @"avatarUrl":[answerData objectForKey: @"coverMiddle"]?:@"",
        };
        thisAnswer.person = [UserBuilder personFromDictionary: ownerValues];
        [question addAnswer: thisAnswer];
    }
    return YES;
}
@end
