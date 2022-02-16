//
//  ZZTopick.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/30.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZTopick.h"
#import "ZZQuestion.h"

@interface ZZTopick ()
@property (nonatomic, copy) NSArray <ZZQuestion *> *questions;
@end
@implementation ZZTopick

- (instancetype)initWithName:(NSString *)name tag:(nonnull NSString *)tag
{
    self = [super init];
    if (self) {
        _name = name;
        _tag = tag;
        self.questions = @[].mutableCopy;
    }
    return self;
}


/*
 这样不够好，与任何话题也关的提问数量都是在无限增长的，尽管应用程序只能看到其中20个，不过多余的对象仍然存在，并且消耗着内存。
 这并非内存泄漏，而是“过时引用”问题。
 采用直接了当的方式解决内存占用问题， 将Topic类重构，返回到上一次修改之前的状态，在addQuestion方法中将最早的那么个提问对象删除掉。
 */
//- (NSArray<ZZQuestion *> *)recentQuestions {
//    // 按照时间顺序对Question进行排序
//   NSArray *sortQuestions =  [self.questions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        ZZQuestion *q1 = (ZZQuestion *)obj1;
//        ZZQuestion *q2 = (ZZQuestion *)obj2;
//        return [q2.date compare:q1.date];
//    }];
//
//    if (sortQuestions.count < 21) {
//        return sortQuestions;
//    } else {
//        return [sortQuestions subarrayWithRange:NSMakeRange(0, 20)];
//    }
//}


//- (void)addQuestion:(ZZQuestion *)question {
//    self.questions = [self.questions arrayByAddingObject:question].mutableCopy;
//}

- (void)addQuestion:(ZZQuestion *)question {
    NSArray *newQuestions = [self.questions arrayByAddingObject:question];
    if (newQuestions.count > 20) {
        newQuestions = [self sortQuestionsLatestFirst:newQuestions];
        newQuestions = [newQuestions subarrayWithRange:NSMakeRange(0, 20)];
    }
    self.questions = newQuestions;
}

- (NSArray<ZZQuestion *> *)recentQuestions {
    return [self sortQuestionsLatestFirst:self.questions];
}

- (NSArray *)sortQuestionsLatestFirst:(NSArray *)questionList {
    return [questionList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         ZZQuestion *q1 = (ZZQuestion *)obj1;
         ZZQuestion *q2 = (ZZQuestion *)obj2;
         return [q2.date compare:q1.date];
    }];
}

@end
