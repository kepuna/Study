//
//  ZZCocurrentOperation.m
//  ZZKit
//
//  Created by donews on 2019/7/12.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZCocurrentOperation.h"
/*
 自定义并发的NSOperation需要以下步骤
 
 1.start方法：该方法必须实现
 2.main:该方法可选，如果你在start方法中定义了你的任务，则这个方法就可以不实现，但通常为了代码逻辑清晰，通常会在该方法中定 义自己的任务
 3.isExecuting isFinished 主要作用是在线程状态改变时，产生适当的KVO通知
 4.isConcurrent :必须覆盖并返回YES
 */
@implementation ZZCocurrentOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}



#pragma mark - Getters & Setters
- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting { 
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)start {
    //第一步就要检测是否被取消了，如果取消了，要实现相应的KVO
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    //如果没被取消，开始执行任务
    [self willChangeValueForKey:@"isExecuting"];
    //执行任务
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    @try {
        @autoreleasepool {
            //在这里定义自己的并发任务
            NSLog(@"自定义并发操作NSOperation");
            NSLog(@"%@",[NSThread currentThread]);
            
             //任务执行完成后要实现相应的KVO
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isExecuting"];
            executing = NO;
            finished = YES;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];  
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
