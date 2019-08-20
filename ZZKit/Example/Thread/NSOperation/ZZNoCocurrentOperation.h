//
//  ZZNoCocurrentOperation.h
//  ZZKit
//
//  Created by donews on 2019/7/11.
//  Copyright © 2019年 donews. All rights reserved.
// 非并发的NSOperation比较简单

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 一：定义非并发的NSOperation比较简单
    1.实现main方法，在main方法中执行自定义的任务
    2.正确的响应取消事件
 */

@interface ZZNoCocurrentOperation : NSOperation

@end

NS_ASSUME_NONNULL_END
