//
//  QuestionBuilder.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//


#import "QuestionBuilder.h"
#import "ZZQuestion.h"
#import "ZZPerson.h"
#import "UserBuilder.h"

NSString *QuestionBuilderErrorDomain = @"QuestionBuilderErrorDomain";

@implementation QuestionBuilder

- (NSArray *)questionsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error {
//    
//    if (objectNotation == nil) {
//        return nil;
//    }
    NSParameterAssert(objectNotation != nil);
    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: &localError];
    NSDictionary *parsedObject = (id)jsonObject;
    
    // Error
    if (parsedObject == nil) {
        if (error != NULL) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain code: QuestionBuilderInvalidJSONError userInfo: userInfo];
        }
        return nil;
    }
    
    NSArray *questions = [parsedObject objectForKey: @"questions"];
    if (questions && [questions isKindOfClass:NSArray.class]) {
        
        NSMutableArray *results = [NSMutableArray arrayWithCapacity: [questions count]];
        for (NSDictionary *parsedQuestion in questions) {
            ZZQuestion *thisQuestion = [[ZZQuestion alloc] init];
            thisQuestion.questionID = [[parsedQuestion objectForKey: @"question_id"] integerValue];
            thisQuestion.date = [NSDate dateWithTimeIntervalSince1970: [[parsedQuestion objectForKey: @"creation_date"] doubleValue]];
            thisQuestion.title = [parsedQuestion objectForKey: @"title"];
            thisQuestion.score = [[parsedQuestion objectForKey: @"score"] integerValue];
            NSDictionary *ownerValues = [parsedQuestion objectForKey: @"owner"];
            thisQuestion.asker = [UserBuilder personFromDictionary: ownerValues];
            [results addObject: thisQuestion];
        }
        return [results copy];
        
    } else {
        
        NSDictionary *dataDict = [parsedObject objectForKey: @"data"];
        NSArray *questions = [dataDict objectForKey: @"list"];
        if (questions == nil) {
            if (error != NULL) {
                *error = [NSError errorWithDomain:QuestionBuilderErrorDomain code: QuestionBuilderMissingDataError userInfo:nil];
            }
            return nil;
        }
        
        NSMutableArray *results = [NSMutableArray arrayWithCapacity: [questions count]];
        for (NSDictionary *parsedQuestion in questions) {
            ZZQuestion *thisQuestion = [[ZZQuestion alloc] init];
            thisQuestion.questionID = [[parsedQuestion objectForKey: @"albumId"] integerValue];
            thisQuestion.date = [NSDate dateWithTimeIntervalSince1970: [[parsedQuestion objectForKey: @"lastUptrackAt"] doubleValue]];
            thisQuestion.title = [parsedQuestion objectForKey: @"title"];
            thisQuestion.score = [[parsedQuestion objectForKey: @"tracks"] integerValue];
            NSDictionary *ownerValues = @{
                @"nickname":[parsedQuestion objectForKey: @"nickname"]?:@"",
                @"avatarUrl":[parsedQuestion objectForKey: @"coverMiddle"]?:@"",
            };
            thisQuestion.asker = [UserBuilder personFromDictionary: ownerValues];
            [results addObject: thisQuestion];
        }
        return [results copy];
    }
}

- (void)fillInDetailsForQuestion:(ZZQuestion *)question fromJSON:(NSString *)objectNotation {
    
//    if (question == nil || objectNotation == nil) {
//        return;
//    }
    NSParameterAssert(question != nil);
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: NULL];
    if (![parsedObject isKindOfClass: [NSDictionary class]]) {
        return;
    }
    NSDictionary *dataDict = [parsedObject objectForKey: @"data"];
    NSArray *questions = [dataDict objectForKey: @"list"];
    NSDictionary *dictBody = questions.firstObject;
    if (dictBody) {
        NSString *questionBody = [dictBody objectForKey: @"info"];
        if (questionBody) {
            question.body = questionBody;
        }
    }
}

@end
