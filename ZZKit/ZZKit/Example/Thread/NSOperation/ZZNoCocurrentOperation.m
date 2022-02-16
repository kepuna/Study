//
//  ZZNoCocurrentOperation.m
//  ZZKit
//
//  Created by donews on 2019/7/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZNoCocurrentOperation.h"

// 在ZZNoCocurrentOperation中要注意两点 1.创建释放池 2.正确响应取消事件
@implementation ZZNoCocurrentOperation

- (void)main {
    @try {
        //在这里我们要创建自己的释放池，因为这里我们拿不到主线程的释放池
        @autoreleasepool {
            BOOL isDone = NO;
            //正确的响应取消事件
            while(![self isCancelled] && !isDone)
            {
                //在这里执行自己的任务操作
                NSLog(@"执行自定义非并发NSOperation");
                NSThread *thread = [NSThread currentThread];
                NSLog(@"%@",thread);
                
                //任务执行完成后将isDone设为YES
                isDone = YES;
            } 
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

@end
