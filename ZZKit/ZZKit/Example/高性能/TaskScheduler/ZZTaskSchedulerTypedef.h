//
//  ZZTaskSchedulerTypedef.h
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#ifndef ZZTaskSchedulerTypedef_h
#define ZZTaskSchedulerTypedef_h

typedef NS_ENUM(NSInteger, ZZTaskSchedulerStrategy) {
    ZZTaskSchedulerStrategyLIFO,    //后进先出（后进任务优先级高）
    ZZTaskSchedulerStrategyFIFO,    //先进先出（先进任务优先级高）
    ZZTaskSchedulerStrategyPriority   //优先级调度（自定义任务的优先级）
};

typedef NSInteger ZZTaskPriority;
static const ZZTaskPriority ZZTaskPriorityHigh = 750;
static const ZZTaskPriority ZZTaskPriorityDefault = 500;
static const ZZTaskPriority ZZTaskPriorityLow = 250;

typedef void(^ZZTaskBlock)(void);


#endif /* ZZTaskSchedulerTypedef_h */
