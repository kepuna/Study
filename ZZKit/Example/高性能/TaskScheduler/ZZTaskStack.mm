//
//  ZZTaskStack.m
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZTaskStack.h"
#import <pthread.h>
#include <deque>

using  namespace std;

@implementation ZZTaskStack {
    
    deque<ZZTaskBlock> _deque;
    pthread_mutex_t _lock;
}
@synthesize zz_maxNumberOfTasks = _zz_maxNumberOfTasks;

- (void)dealloc {
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

#pragma mark - private
- (void)clearTasks {
    pthread_mutex_lock(&_lock);
    _deque.clear();
    pthread_mutex_unlock(&_lock);
}

#pragma mark - 实现协议的方法
#pragma mark - <ZZTaskSchedulerStrategyProtocol>

- (BOOL)zz_empty {
    return _deque.empty();
}

- (void)zz_clearTasks {
    [self clearTasks];
}

- (void)zz_addTask:(ZZTaskBlock)task priority:(ZZTaskPriority)priority {
    if (task == nil) {
        return;
    }
    
    pthread_mutex_lock(&_lock);
    _deque.push_front(task);
    if (self.zz_maxNumberOfTasks > 0) {
        while (_deque.size() > self.zz_maxNumberOfTasks) {
            _deque.pop_front();
        }
    }
    
    pthread_mutex_unlock(&_lock);
    
}

- (void)zz_executeTask {
    pthread_mutex_lock(&_lock);
    if (_deque.empty()) {
        pthread_mutex_unlock(&_lock);
        return;
    }
    
    ZZTaskBlock taskBlock = (ZZTaskBlock) _deque.back();
    _deque.pop_back();
    pthread_mutex_unlock(&_lock);
    
    taskBlock();
}

@end
