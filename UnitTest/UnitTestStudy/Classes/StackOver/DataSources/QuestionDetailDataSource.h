//
//  QuestionDetailDataSource.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  提问详情

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZZQuestion;
@class QuestionDetailCell;
@class AnswerCell;
@class AvatarStore;

NS_ASSUME_NONNULL_BEGIN

@interface QuestionDetailDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZZQuestion *question;
@property (nonatomic, weak) QuestionDetailCell *detailCell;
@property (nonatomic, weak) AnswerCell *answerCell;
@property (nonatomic, strong) AvatarStore *avatarStore;

@end

NS_ASSUME_NONNULL_END
