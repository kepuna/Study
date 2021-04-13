//
//  ZZTaskScheduler.m
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZTaskScheduler.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

#import "ZZTaskStack.h"
#import "ZZTaskQueue.h"
#import "ZZPriorityQueue.h"
#import "ZZTaskScheduler+Internal.h"


static dispatch_queue_t ZZDefaultConcurrentQueue()
{
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
   
    static int32_t counter = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 8 ? 8 : (queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount);
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            
            for (NSInteger i=0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
                queues[i] = dispatch_queue_create("com.zz.taskscheduler", attr);
            }
        } else {
            for (NSInteger i=0; i<queueCount; i++) {
                queues[i] = dispatch_queue_create("com.zz.taskscheduler", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    
    uint32_t cur = (uint32_t)OSAtomicIncrement32(&counter);
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}


static NSHashTable *ZZTaskSchedulers(void) {
    
    static NSHashTable *schedulers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schedulers  = [NSHashTable weakObjectsHashTable];
    });
    return schedulers;
}

static CADisplayLink *ZZDisplayLink(void) {
    static CADisplayLink *displayLink = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayLink = [CADisplayLink displayLinkWithTarget:ZZTaskScheduler.self selector:@selector(hash)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    });
    return displayLink;
}

static void ZZRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    BOOL keepActive = NO;
    for (ZZTaskScheduler *scheduler in ZZTaskSchedulers().allObjects) {
        if (!scheduler.empty) {
            keepActive = YES;
            [scheduler executeTasks]; // 执行任务
        }
    }
    
    if (ZZDisplayLink().paused == keepActive) {
        ZZDisplayLink().paused = !keepActive;
    }
}

static void ZZAddRunLoopObserver() {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0xFFFFFF, ZZRunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation ZZTaskScheduler
{
    
    id <ZZTaskSchedulerStrategyProtocol> _stragegy;
    NSUInteger _frequencyCounter;
}

- (instancetype)initWithStrategyObject:(id <ZZTaskSchedulerStrategyProtocol>)strategyObject {
    self = [super init];
    if (self) {
        ZZAddRunLoopObserver();
        self.executeNumber = 1;
        self.maxNumberOfTasks = NSUIntegerMax;
        self.executeFrequency = 1;
        _stragegy = strategyObject;
        
        // 每创建一个 TaskScheduler 就放入 HashMap
        [ZZTaskSchedulers() addObject:self];
        
    }
    return self;
}

- (instancetype)initWithStrategy:(ZZTaskSchedulerStrategy)strategy
{
    id <ZZTaskSchedulerStrategyProtocol> strategyObject;
    
    switch (strategy) {
        case ZZTaskSchedulerStrategyLIFO:
            strategyObject = [ZZTaskStack new];
            break;
        
        case ZZTaskSchedulerStrategyFIFO:
            strategyObject = [ZZTaskQueue new];
            break;
        case ZZTaskSchedulerStrategyPriority:
            strategyObject = [ZZPriorityQueue new];
            break;
        default:
            break;
    }
    return [self initWithStrategyObject:strategyObject];
}

+ (instancetype)schedulerWithStrategy:(ZZTaskSchedulerStrategy)strategy {
    return [[ZZTaskScheduler alloc] initWithStrategy:strategy];
}

#pragma mark - public
- (void)addTask:(ZZTaskBlock)task {
    [self addTask:task priority:ZZTaskPriorityDefault];
}

- (void)addTask:(ZZTaskBlock)task priority:(ZZTaskPriority)priority {
    if (task == nil) {
        return;
    }
    [_stragegy zz_addTask:task priority:priority];
    ZZDisplayLink().paused = NO;
}

- (void)clearTasks {
    [_stragegy zz_clearTasks];
}

- (BOOL)empty {
    return _stragegy.zz_empty;
}

- (void)executeTasks {
    
    if (_frequencyCounter != self.executeFrequency) {
        ++ _frequencyCounter;
        return;
    } else {
        _frequencyCounter = 1;
    }
    
    if (_stragegy.zz_empty) {
        return;
    }
    dispatch_block_t taskBlock = ^{
        [self->_stragegy zz_executeTask];
    };
    
    // ????
    BOOL needSwitchQueue = !self.taskQueue || strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(self.taskQueue)) != 0;
    
    void(^executeBlock)(void) = nil;
    if (needSwitchQueue) {
        executeBlock = ^{
            dispatch_async(self.taskQueue?:ZZDefaultConcurrentQueue(), taskBlock);
        };
    } else {
        executeBlock = taskBlock;
    }
    
    // 执行任务
    for (NSInteger i = 0; i < self.executeNumber; i++) {
        executeBlock();
    }
}



#pragma mark - setter

- (void)setMaxNumberOfTasks:(NSUInteger)maxNumberOfTasks {
    _maxNumberOfTasks = maxNumberOfTasks;
    if ([_stragegy respondsToSelector:@selector(setZz_maxNumberOfTasks:)]) {
        _stragegy.zz_maxNumberOfTasks = maxNumberOfTasks;
    }
}
@end
