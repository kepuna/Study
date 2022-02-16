//
//  ZZTopick.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/30.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  话题的类

#import <Foundation/Foundation.h>
@class ZZQuestion;
NS_ASSUME_NONNULL_BEGIN

@interface ZZTopick : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *tag;

/// 最近提问
@property (nonatomic, readonly, copy) NSArray <ZZQuestion *> *recentQuestions;

- (instancetype)initWithName:(NSString *)name tag:(NSString *)tag;

- (void)addQuestion:(ZZQuestion *)question;

@end

NS_ASSUME_NONNULL_END
