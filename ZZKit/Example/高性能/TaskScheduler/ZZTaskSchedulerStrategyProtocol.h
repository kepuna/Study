//
//  ZZTaskSchedulerStrategyProtocol.h
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTaskSchedulerTypedef.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZZTaskSchedulerStrategyProtocol <NSObject>

@required;


/// 添加任务
/// @param task 任务
/// @param priority 任务优先级
- (void)zz_addTask:(ZZTaskBlock)task priority:(ZZTaskPriority)priority;

- (void)zz_executeTask;

- (void)zz_clearTasks;

- (BOOL)zz_empty;

@optional;

/// 最大持有任务数量
@property (nonatomic, assign) NSUInteger zz_maxNumberOfTasks;

@end

NS_ASSUME_NONNULL_END
