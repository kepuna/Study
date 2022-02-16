//
//  ZZAnswer.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  回答提问的类

#import <Foundation/Foundation.h>
@class ZZPerson;
NS_ASSUME_NONNULL_BEGIN

@interface ZZAnswer : NSObject

@property (nonatomic, copy) NSString *text;
// 回答问题的人
@property (nonatomic, strong) ZZPerson *person;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) BOOL accepted;


- (NSComparisonResult)compare: (ZZAnswer *)otherAnswer;

@end

NS_ASSUME_NONNULL_END
