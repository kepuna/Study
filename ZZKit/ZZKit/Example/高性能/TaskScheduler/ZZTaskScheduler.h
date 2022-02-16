//
//  ZZTaskScheduler.h
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTaskSchedulerTypedef.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZTaskScheduler : NSObject

/// init method
/// @param strategy 调度策略
- (instancetype)initWithStrategy:(ZZTaskSchedulerStrategy)strategy;

+ (instancetype)schedulerWithStrategy:(ZZTaskSchedulerStrategy)strategy;

/// 线程队列 （若不指定 ，任务会在子线程并行执行）
@property (nonatomic, strong, nullable) dispatch_queue_t taskQueue;

/// 最大持有任务数量（调度策略为 YBTaskSchedulerStrategyPriority 时无效）
@property (nonatomic, assign) NSUInteger maxNumberOfTasks;

/* 每次执行的任务数量 */
@property (nonatomic, assign) NSUInteger executeNumber;

/* 执行频率（RunLoop 循环 executeFrequency 次执行一次任务） */
@property (nonatomic, assign) NSUInteger executeFrequency;


/**
 添加任务

 @param task 包裹任务的 block
 */
- (void)addTask:(ZZTaskBlock)task;

/**
 添加带优先级的任务（优先级仅在调度策略为 YBTaskSchedulerStrategyPriority 时有效）

 @param task 包裹任务的 block
 @param priority 优先级
 */
- (void)addTask:(ZZTaskBlock)task priority:(ZZTaskPriority)priority;

/**
 清空所有任务
 */
- (void)clearTasks;


- (instancetype)init OBJC_UNAVAILABLE("use '-initWithStrategy:' or '+schedulerWithStrategy:' instead");
+ (instancetype)new OBJC_UNAVAILABLE("use '-initWithStrategy:' or '+schedulerWithStrategy:' instead");

@end

NS_ASSUME_NONNULL_END
