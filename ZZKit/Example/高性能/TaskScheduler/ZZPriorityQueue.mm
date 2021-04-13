//
//  ZZPriorityQueue.m
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZPriorityQueue.h"
#import <pthread.h>
#include <queue>
#include <vector>

using namespace std;

// 结构体
struct ZZPQTask {
    ZZTaskBlock taskBlock;
    NSUInteger priority;
    CFTimeInterval time;
};

// 创建方法
ZZPQTask ZZPQTaskMake(ZZTaskBlock taskBlcok, NSUInteger priority, CFTimeInterval time) {
    ZZPQTask pqTask;
    pqTask.taskBlock = taskBlcok;
    pqTask.priority = priority;
    pqTask.time = time;
    return pqTask;
}

struct ZZPQMP {
    bool operator()(ZZPQTask a, ZZPQTask b) {
        if (a.priority == b.priority) {
            return a.time < b.time;
        }
        return a.priority < b.priority;
    }
};

/// 优先级队列
@implementation ZZPriorityQueue {
 
    priority_queue<ZZPQTask, vector<ZZPQTask>, ZZPQMP> _queue;
    pthread_mutex_t _lock;
};

- (void)dealloc
{
    [self clearTasks];
    pthread_mutex_destroy(&_lock);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_lock, &attr);
        pthread_mutexattr_destroy(&attr);
    }
    return self;
}

- (void)clearTasks {
    pthread_mutex_lock(&_lock);
    while (!_queue.empty()) {
        _queue.pop();
    }
    pthread_mutex_unlock(&_lock);
}

#pragma mark - 实现协议的方法
#pragma mark - <ZZTaskSchedulerStrategyProtocol>

- (BOOL)zz_empty {
    return _queue.empty();
}

- (void)zz_clearTasks {
    [self clearTasks];
}

- (void)zz_addTask:(ZZTaskBlock)task priority:(ZZTaskPriority)priority {
    if (task == nil) {
        return;
    }
    pthread_mutex_lock(&_lock);
    _queue.push(ZZPQTaskMake(task, priority, CFAbsoluteTimeGetCurrent()));
    pthread_mutex_unlock(&_lock);
}

- (void)zz_executeTask {
    pthread_mutex_lock(&_lock);
    if (_queue.empty()) {
        pthread_mutex_unlock(&_lock);
        return;
    }
    
    ZZPQTask pqTask = (ZZPQTask)_queue.top();
    ZZTaskBlock taskBlock = pqTask.taskBlock;
    _queue.pop();
    pthread_mutex_unlock(&_lock);
    
    taskBlock();
}

@end
